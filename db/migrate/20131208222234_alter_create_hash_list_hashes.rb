class AlterCreateHashListHashes < ActiveRecord::Migration
	def change
		change_column :hash_list_hashes, :hash_list_id, :integer
		change_column :hash_list_hashes, :md5_hash_id, :integer
	end
end
