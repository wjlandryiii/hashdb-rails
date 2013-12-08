class HashList < ActiveRecord::Base
	attr_accessible :title, :description
	has_many :hash_list_hashes, :dependent => :delete_all
end