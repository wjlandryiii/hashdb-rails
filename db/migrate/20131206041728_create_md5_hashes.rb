class CreateMd5Hashes < ActiveRecord::Migration
	def change
		create_table :md5_hashes do |t|
			t.string :hex_hash
			t.string :password
		end
		add_index "md5_hashes", ["hex_hash"], :name => "index_md5_hashes_on_hex_hash", :unique => true
		add_index "md5_hashes", ["password"], :name => "index_md5_hashes_on_password", :unique => true
	end
end
