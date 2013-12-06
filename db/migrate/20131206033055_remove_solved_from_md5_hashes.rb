class RemoveSolvedFromMd5Hashes < ActiveRecord::Migration
  def up
    remove_column :md5_hashes, :solved
    remove_column :md5_hashes, :solution
  end

  def down
    add_column :md5_hashes, :solution, :string
    add_column :md5_hashes, :solved, :string
  end
end
