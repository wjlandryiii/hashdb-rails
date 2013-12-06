class AddIndexToPlainTexts < ActiveRecord::Migration
  def change
    add_index :plain_texts, :plainTextString, :unique => true
  end
end
