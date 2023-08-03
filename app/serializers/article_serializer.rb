class ArticleSerializer < ActiveModel::Serializer

  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :tags, :author_id , :created_at, :topic, :image_url, :likes, :comments, :views

  def image_url
    if object.image.attached?
      url_for(object.image)
    end
  end

  
end
