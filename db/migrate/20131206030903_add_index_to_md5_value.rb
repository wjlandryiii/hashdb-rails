class AddIndexToMd5Value < ActiveRecord::Migration
  def change
    add_index :md5_hashes, :md5_value, :unique => true
  end
end
