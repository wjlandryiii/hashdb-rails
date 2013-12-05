class CreatePlainTexts < ActiveRecord::Migration
  def change
    create_table :plain_texts do |t|
      t.string :plainTextString

      t.timestamps
    end
  end
end
