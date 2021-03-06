#coding: utf-8
class Reservation < ActiveRecord::Base

  default_scope order('reservations.id desc')
  scope :exclude_canceled, where(:status.ne => "canceled")
  belongs_to :spot
  belongs_to :agent
  belongs_to :user
  belongs_to :ticket
  belongs_to :purchase_history

  validates :contact, :presence => true
  validates :phone, :presence => true
  validates :spot_id, :presence => true
  validates :group_no, :presence => true
  validates_numericality_of :adult_ticket_number, :greater_than => 0, :message => "成人票数量不能为0和负数"
  validates_numericality_of :child_ticket_number, :greater_than => -1, :message => "儿童票数量不能为负数", :allow_blank => true

  after_create :set_no

  def self.with_status(status)
    case status
      when "confirmed"
        where(:status => status, :date.gte => Date.today)
      when "outdated"
        where(:status => "confirmed", :date.lt => Date.today)
      else
        where(:status => status)
    end
  end

  def self.start_book_date(start_date)
    where(:created_at.gte => DateTime.parse(start_date).beginning_of_day)
  end

  def self.end_book_date(end_date)
    where(:created_at.lte => DateTime.parse(end_date).end_of_day)
  end

  search_methods :with_status, :start_book_date, :end_book_date

  def set_no
    self.no = (100000 + self.id).to_s
    self.save
  end

  def status_name
    case self.status
      when 'confirmed'
        if self.date >= Date.today
          '已确认'
        else
          '已过期'
        end
      when 'canceled'
        '已取消'
      when 'checkedin'
        '已入园'
    end
  end

  def settled_name
    self.settled? ? '已结算' : '未结算'
  end

  def paid_name
    self.paid? ? '已支付' : '未支付'
  end


  def can_edit
    if self.status == "confirmed"
      case self.payment_method
        when "poa"
          true
        when "prepay"
          self.verified == false
        when "net"
          self.paid == false
      end
    else
      false
    end
  end

  def can_edit_after_checkin
    self.status == "checkedin" && self.date == Date.today && !self.settled
  end

  def can_cancel
    is_confirmed?
  end

  def is_confirmed?
    self.status == "confirmed" && self.date >= Date.today
  end

  def need_pay?
    !self.is_expired? && self.payment_method == "net" && self.paid? == false
  end

  def is_expired?
    self.status == "confirmed" && self.date < Date.today
  end

  def self.search_for_today(search)
    today_and_confirmed = where({:date.in => (Date.today - 1)..(Date.today + 1), :status.eq => :confirmed})
    if search
      today_and_confirmed =
          today_and_confirmed.where((:phone.matches % "#{search}%" | :contact.matches % "%#{search}%" | :no.matches % "%#{search}%" | :group_no.matches % "%#{search}%"))
    end
    today_and_confirmed
  end

  def self.day_between(start_date, end_date)
    where(:created_at => start_date..end_date)
  end

   def self.date_between(start_date, end_date)
    where(:date => start_date..end_date)
  end

  def self.sum_output_between(start_time, end_time)

    select('count(1) as count_sum, sum(adult_ticket_number) as adult_ticket_sum, sum(child_ticket_number) as child_ticket_sum,
                sum(adult_true_ticket_number) as adult_true_ticket_sum,sum(child_true_ticket_number) as child_true_ticket_sum,
                sum(book_price) as price_sum').where(:created_at => start_time..end_time)[0]

  end

  def self.sum_checkin_between(start_time, end_time)
    select('count(1) as count_sum, sum(adult_true_ticket_number) as adult_ticket_sum, sum(child_true_ticket_number) as child_ticket_sum,
                sum(adult_true_ticket_number) as adult_true_ticket_sum,sum(child_true_ticket_number) as child_true_ticket_sum,
                sum(total_price) as price_sum').where(:date => start_time..end_time, :status => "checkedin")[0]
  end


  def self.sum_agent_output_between(start_time, end_time)

    select('agent_id,agents.name as agent_name,count(1) as count_sum, sum(adult_ticket_number) as adult_ticket_sum, sum(child_ticket_number) as child_ticket_sum,
                sum(adult_true_ticket_number) as adult_true_ticket_sum,sum(child_true_ticket_number) as child_true_ticket_sum,
                sum(book_price) as price_sum').joins(:agent).group(:agent_id).where(:date => start_time..end_time).reorder(:agent_id)

  end

  def self.sum_spot_output_between(start_time, end_time)

    select('reservations.spot_id,spots.name as spot_name,count(1) as count_sum, sum(adult_ticket_number) as adult_ticket_sum, sum(child_ticket_number) as child_ticket_sum,
                sum(adult_true_ticket_number) as adult_true_ticket_sum,sum(child_true_ticket_number) as child_true_ticket_sum,
                sum(book_price) as price_sum').joins(:spot).group(:spot_id).where(:date => start_time..end_time).reorder(:spot_id)

  end

  def self.sum_user_output_between(start_time, end_time)
    select('user_id,users.name as user_name,count(1) as count_sum, sum(adult_ticket_number) as adult_ticket_sum, sum(child_ticket_number) as child_ticket_sum,
                sum(adult_true_ticket_number) as adult_true_ticket_sum,sum(child_true_ticket_number) as child_true_ticket_sum,
                 sum(book_price) as price_sum').joins(:user).group(:user_id).where(:created_at => start_time..end_time).reorder(:user_id)

  end


  def self.sum_purchase_with_agents
    prepay_purchase_sum = select('agent_id,agents.name as agent_name,type,payment_method,count(1) as count_sum,
                sum(total_purchase_price) as price_sum').joins(:agent).group(:agent_name, :type, :payment_method).where(:settled => false, :payment_method => 'prepay', :status => "checkedin").reorder(:agent_id)
    poa_purchase_sum = select('agent_id,agents.name as agent_name,type,payment_method,count(1) as count_sum,
                sum(total_price-total_purchase_price)  as price_sum').joins(:agent).group(:agent_name, :type, :payment_method).where(:settled => false, :payment_method => 'poa', :type => "IndividualReservation", :status => "checkedin").reorder(:agent_id)
    net_purchase_sum = select('agent_id,agents.name as agent_name,type,payment_method,count(1) as count_sum,
                sum(book_purchase_price-total_purchase_price)  as price_sum').joins(:agent).group(:agent_name, :type, :payment_method).where(:settled => false, :payment_method => 'net', :type => "IndividualReservation", :status => "checkedin").reorder(:agent_id)
    (prepay_purchase_sum + poa_purchase_sum + net_purchase_sum.reject { |item| item.price_sum == 0 }).sort_by(&:agent_name)
  end

  def self.sum_purchase_with_spots
    prepay_purchase_sum = select('spot_id,spots.name as spot_name,type,payment_method,count(1) as count_sum,
                sum(total_purchase_price) as price_sum').joins(:spot).group(:spot_name, :type, :payment_method).where(:settled => false, :payment_method => 'prepay', :status => "checkedin").reorder(:spot_id)
    poa_purchase_sum = select('spot_id,spots.name as spot_name,type,payment_method,count(1) as count_sum,
                sum(total_price-total_purchase_price)  as price_sum').joins(:spot).group(:spot_name, :type, :payment_method).where(:settled => false, :payment_method => 'poa', :type => "IndividualReservation", :status => "checkedin").reorder(:spot_id)
    net_purchase_sum = select('spot_id, spots.name as spot_name,type,payment_method,count(1) as count_sum,
                  sum(book_purchase_price - total_purchase_price) as price_sum').joins(:spot).group(:spot_name, :type, :payment_method).where(:settled => false, :payment_method => 'net', :status => "checkedin").reorder(:spot_id)
    (prepay_purchase_sum + poa_purchase_sum + net_purchase_sum).sort_by(&:spot_name)
  end


  def self.sum_purchase_with_all
    prepay_purchase_sum = select('spot_id,spots.name as spot_name,agent_id,agents.name as agent_name,type,payment_method,count(1) as count_sum,
                sum(total_purchase_price) as price_sum').joins(:spot, :agent).group(:spot_name, :agent_name, :type, :payment_method).where(:settled => false, :payment_method => 'prepay', :status => "checkedin").reorder(:spot_id)
    poa_purchase_sum = select('spot_id,spots.name as spot_name,agent_id,agents.name as agent_name,type,payment_method,count(1) as count_sum,
                sum(total_price-total_purchase_price)  as price_sum').joins(:spot, :agent).group(:spot_name, :agent_name, :type, :payment_method).where(:settled => false, :payment_method => 'poa', :type => "IndividualReservation", :status => "checkedin").reorder(:spot_id)
    net_purchase_sum = select('spot_id,spots.name as spot_name,agent_id,agents.name as agent_name,type,payment_method,count(1) as count_sum,
                sum(book_purchase_price - total_purchase_price)  as price_sum').joins(:spot, :agent).group(:spot_name, :agent_name, :type, :payment_method).where(:settled => false, :payment_method => 'poa', :type => "IndividualReservation", :status => "checkedin").reorder(:spot_id)
    (prepay_purchase_sum + poa_purchase_sum + net_purchase_sum).sort_by(&:spot_name)
  end

  def self.used_contacts(search)
    select('distinct(contact), phone').where(:contact.matches => "#{search}%")
  end


end

# == Schema Information
#
# Table name: reservations
#
#  id                       :integer(4)      not null, primary key
#  no                       :string(255)
#  agent_id                 :integer(4)
#  spot_id                  :integer(4)
#  ticket_name              :string(255)
#  child_sale_price         :integer(4)
#  child_purchase_price     :integer(4)
#  adult_sale_price         :integer(4)
#  adult_purchase_price     :integer(4)
#  adult_price              :integer(4)
#  child_price              :integer(4)
#  child_ticket_number      :integer(4)      default(0)
#  adult_ticket_number      :integer(4)      default(1)
#  date                     :date
#  type                     :string(255)
#  status                   :string(255)
#  contact                  :string(255)
#  phone                    :string(255)
#  total_price              :integer(4)
#  total_purchase_price     :integer(4)
#  paid                     :boolean(1)
#  adult_true_ticket_number :integer(4)
#  child_true_ticket_number :integer(4)
#  created_at               :datetime
#  updated_at               :datetime
#  payment_method           :string(255)
#  book_price               :integer(4)
#  book_purchase_price      :integer(4)
#  group_no                 :string(255)
#  purchase_history_id      :integer(4)
#  note                     :text
#  user_id                  :integer(4)
#  verified                 :boolean(1)      default(FALSE)
#  settled                  :boolean(1)
#  pay_id                   :string(255)
#  pay_time                 :datetime
#

