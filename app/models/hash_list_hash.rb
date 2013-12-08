class HashListHash < ActiveRecord::Base
	belongs_to :hash_list
	belongs_to :md5_hash
end