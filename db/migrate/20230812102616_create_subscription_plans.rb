class CreateSubscriptionPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_plans do |t|
      t.string :name
      t.integer :price
      t.integer :daily_article_limit

      t.timestamps
    end
  end
end
