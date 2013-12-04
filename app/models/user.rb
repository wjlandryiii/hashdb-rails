class User < ActiveRecord::Base
	attr_accessor :md5_hash_value
	attr_accessible :client, :md5_hash_id, :name, :md5_hash_value
	belongs_to :md5_hash

end
