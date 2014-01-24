class RemovePasswordFromUsers < ActiveRecord::Migration
  def up
	remove_columns :users, :password
  end
  
  def down
	add_column :users, :password, :string
  end
end
