class AddDefaultValuesToArticles < ActiveRecord::Migration[7.0]
  def change
    change_column_default :articles, :likes, 0
    change_column_default :articles, :comments, 0
    change_column_default :articles, :views, 0
  end
end
