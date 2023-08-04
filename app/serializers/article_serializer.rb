class ArticleSerializer < ActiveModel::Serializer

  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :tags , :topic, :image_url
  # , :likes, :comments, :views, :created_at, :author_id

  def image_url
    if object.image.attached?
      url_for(object.image)
    end
  end

  
end
