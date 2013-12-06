class AddMd5HashToPlainTexts < ActiveRecord::Migration
  def change
    add_column :plain_texts, :md5_hash_id, :integer
  end
end
