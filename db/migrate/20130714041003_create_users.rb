class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :client
      t.string :name
      t.string :md5_hash_id

      t.timestamps
    end
  end
end
