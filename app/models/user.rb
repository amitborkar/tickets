#coding:utf-8

class User < ActiveRecord::Base
  attr_accessor :password
  before_save :prepare_password

  validates_presence_of :username
  validates_uniqueness_of :username, :allow_blank => true, :case_sensitive => false
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "只能包含数字，字母或下划线"
  validates_presence_of :name
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  belongs_to :role
  has_many :reservations

  def self.authenticate(login, pass)
    user = find_by_username_and_deleted(login,false)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  def menu_groups
    role.menu_groups
  end



  def is_spot_price_all
    self.spot_price_cat == 'all' || self.type != 'AgentOperator'
  end

  def has_spot_team_price
    self.spot_price_cat == 'team'
  end

  def has_spot_individual_price
    self.spot_price_cat == 'individual'
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end
end


# == Schema Information
#
# Table name: users
#
#  id             :integer(4)      not null, primary key
#  username       :string(255)
#  email          :string(255)
#  password_hash  :string(255)
#  password_salt  :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  name           :string(255)
#  type           :string(255)
#  spot_id        :integer(4)
#  agent_id       :integer(4)
#  role_id        :integer(4)
#  deleted        :boolean(1)      default(FALSE)
#  spot_price_cat :string(255)     default("team")
#

