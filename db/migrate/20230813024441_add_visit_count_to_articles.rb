class AddVisitCountToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :visit_count, :integer
  end
end
