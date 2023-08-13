class RemoveTopicFromArticles < ActiveRecord::Migration[7.0]
  def change
    remove_column :articles, :topic, :string
  end
end
