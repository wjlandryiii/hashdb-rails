class CreateMd5Hashes < ActiveRecord::Migration
  def change
    create_table :md5_hashes do |t|
      t.string :md5_value
      t.boolean :solved
      t.string :solution

      t.timestamps
    end
  end
end
