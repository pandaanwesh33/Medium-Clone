class Article < ApplicationRecord
    # has_one_attached :image

    has_many :likes
    has_many :liking_users, through: :likes, source: :user

    has_many :comments

    belongs_to :author, class_name: 'User', foreign_key: 'author_id'
    belongs_to :topic
    
    # subscription
    has_many :article_visits

    # attributes for draft and publication
    attribute :published, :boolean, default: false
    attribute :published_at, :datetime

    #save for later
    has_many :saved_articles
    has_many :users, through: :saved_articles, source: :user

    #revision history
    has_many :article_revisions

    def reading_time
        # Average reading speed in words per minute(data taken from IEEE paper)
        average_reading_speed = 200
        
        # Calculate the total word count in the article's content
        word_count = self.description.split.size
        
        # Calculate the estimated reading time in minutes
        estimated_reading_time = (word_count / average_reading_speed).ceil
        
        # Return the reading time in minutes
        estimated_reading_time
      end


end
