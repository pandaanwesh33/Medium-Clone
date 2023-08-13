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

  # subscription
  belongs_to :subscription_plan, default: -> { SubscriptionPlan.find_by(name: "Free") }
  has_many :article_visits

  # follow feature 
  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
    has_many :followees, through: :followed_users
    has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
    has_many :followers, through: :following_users

  def following?(other_user)
      followers.include?(other_user)
  end
end
