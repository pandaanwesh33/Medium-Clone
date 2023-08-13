class SubscriptionPlan < ApplicationRecord
    class SubscriptionPlan < ApplicationRecord
        has_many :users
      
        validates :name, presence: true
        validates :price, presence: true, numericality: { greater_than: 0 }
        validates :daily_article_limit, presence: true, numericality: { greater_than_or_equal_to: 0 }
      end
end
