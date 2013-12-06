class CreateTableHashLists < ActiveRecord::Migration
	def change
		create_table :hash_lists do |t|
			t.string :title
			t.string :description
			t.timestamps
		end
	end
end
