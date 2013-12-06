class RemovePlainTextFromMd5Hashes < ActiveRecord::Migration
  def up
    remove_column :md5_hashes, :plain_text_id
  end

  def down
    add_column :md5_hashes, :plain_text_id, :string
  end
end
