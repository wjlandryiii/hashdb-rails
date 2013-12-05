class AddPlainTextIdToMd5Hashes < ActiveRecord::Migration
  def change
    add_column :md5_hashes, :plain_text_id, :integer
  end
end
