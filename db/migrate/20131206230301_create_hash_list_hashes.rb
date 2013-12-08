class CreateHashListHashes < ActiveRecord::Migration
	def change
		create_table :hash_list_hashes do |t|
			t.string :hash_list_id
			t.string :md5_hash_id
			t.timestamps
		end
	end
end
