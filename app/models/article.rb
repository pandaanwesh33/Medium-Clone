class Article < ApplicationRecord
    has_one_attached :image

    has_many :likes
    has_many :liking_users, through: :likes, source: :user

    has_many :comments

    belongs_to :author, class_name: 'User', foreign_key: 'author_id'
end
