class AddUserIdToBmarks < ActiveRecord::Migration
  def change
    add_column :bmarks, :user_id, :integer
    add_index :bmarks, :user_id
    change_column :bmarks, :user_id, :integer, null: false
  end
end
