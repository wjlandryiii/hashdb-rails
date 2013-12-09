class CreateHashListHashes < ActiveRecord::Migration
	def change
		create_table :hash_list_hashes do |t|
			t.integer :hash_list_id
			t.integer :md5_hash_id
		end
	end
end
