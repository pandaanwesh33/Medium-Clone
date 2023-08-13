class AddSubscriptionPlanAndDailyArticleVisitCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :subscription_plan, foreign_key: true
    add_column :users, :daily_article_visit_count, :integer, default: 0
  end
end
