class CreateArticleVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :article_visits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.datetime :visited_at

      t.timestamps
    end
  end
end
