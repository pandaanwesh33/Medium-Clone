class RemoveSubscriptionLevelFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :subscription_level
  end
end
