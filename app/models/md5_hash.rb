class Md5Hash < ActiveRecord::Base
  attr_accessible :md5_value, :solution, :solved
  validates_uniqueness_of :md5_value
end
