class User < ApplicationRecord
  #automatically ensures password encryption and user authentication
  has_secure_password
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  #dependent: :destroy =>  ensures that when a User record is deleted, all associated Article records with the matching author_id will also be deleted 
  has_many :articles, foreign_key: 'author_id', dependent: :destroy

  has_many :likes
  has_many :liked_articles, through: :likes, source: :article

  has_many :comments

  # follow feature 
  has_many :follows, foreign_key: :user_id, dependent: :destroy
  has_many :followers, through: :follows, source: :follower

  has_many :followings, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :followed_users, through: :followings, source: :user

    def following?(other_user)
      follows.include?(other_user)
  end
end
