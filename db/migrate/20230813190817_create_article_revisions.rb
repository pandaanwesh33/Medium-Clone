class CreateArticleRevisions < ActiveRecord::Migration[7.0]
  def change
    create_table :article_revisions do |t|
      t.references :article, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
