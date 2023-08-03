class AddFieldsToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :topic, :string
    add_column :articles, :author_id, :integer
    add_column :articles, :likes, :integer
    add_column :articles, :comments, :integer
    add_column :articles, :views, :integer
  end
end
