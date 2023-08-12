class AddSubscriptionLevelToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :subscription_level, :integer, default: 0
    add_index :users, :subscription_level
  end
end
