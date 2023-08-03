class RemoveColumnFromArticle < ActiveRecord::Migration[7.0]
  def change
    remove_column :articles, :author, :string
    remove_column :articles, :publish_date, :date
  end
end
