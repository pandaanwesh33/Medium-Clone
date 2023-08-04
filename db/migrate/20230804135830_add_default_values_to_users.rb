class AddDefaultValuesToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :follower_count, 0
    change_column_default :users, :following_count, 0
  end
end
