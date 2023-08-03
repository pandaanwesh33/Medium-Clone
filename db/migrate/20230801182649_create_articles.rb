class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :description
      t.string :tags
      t.string :author
      t.date :publish_date

      t.timestamps
    end
  end
end
