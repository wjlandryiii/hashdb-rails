class PlainText < ActiveRecord::Base
  attr_accessible :plainTextString
  validates :plainTextString, uniqueness: true
  validates :md5_hash, presence: true
  belongs_to :md5_hash, class_name: "Md5Hash"
  after_save
end
