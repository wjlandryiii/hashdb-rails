class ChangeSolvedInMd5Hash < ActiveRecord::Migration
  def up
  	change_column :md5_hashes, :solved, :boolean, :default => false, :null => false
  end

  def down
  end
end
