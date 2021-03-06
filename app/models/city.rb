class City < ActiveRecord::Base
  validates :name, :presence => true
  validates :code, :presence => true
  validates :pinyin, :presence => true

  has_and_belongs_to_many :spots

  def self.search(word)
#    where("name LIKE :word OR pinyin LIKE :word", :word => "#{word}%")
    where(:name.matches % "#{word}%" | :pinyin.matches % "#{word}%")
  end
end

# == Schema Information
#
# Table name: cities
#
#  id         :integer(4)      not null, primary key
#  code       :string(255)
#  name       :string(255)
#  pinyin     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

