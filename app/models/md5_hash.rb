class Md5Hash < ActiveRecord::Base
  attr_accessible :md5_value, :solution, :solved
  validates_uniqueness_of :md5_value
  VALID_MD5_REGEX = /\A([0-9]|[a-f]){32}\z/i
  validates :md5_value, format: {with: VALID_MD5_REGEX }
  belongs_to :plain_text, class_name: "PlainText"

  def to_param
  	md5_value
  end

  class << self
  	def find_or_create(md5_value)
			md5_value.strip!
			md5_value.downcase!
			md5hash = Md5Hash.find_by_md5_value(md5_value)
			if md5hash == nil
				md5hash = Md5Hash.new
				md5hash.md5_value = md5_value
				md5hash.save!
			end
			return md5hash
  	end

  	def find_or_create_from_plaintext(s)
  		md5_value = Digest::MD5.hexdigest(s)
  		return Md5Hash.find_or_create(md5_value)
  	end
  end
end
