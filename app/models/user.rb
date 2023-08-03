class User < ApplicationRecord
    #dependent: :destroy =>  ensures that when a User record is deleted, all associated Article records with the matching author_id will also be deleted 
    has_many :articles, foreign_key: 'author_id', dependent: :destroy

    has_many :likes
    has_many :liked_articles, through: :likes, source: :article

    has_many :comments

    #automatically ensures password encryption and user authentication
    has_secure_password
end
