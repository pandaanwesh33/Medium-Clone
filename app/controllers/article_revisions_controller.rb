class ArticleRevisionsController < ApplicationController

    skip_before_action :verify_authenticity_token
    before_action :authenticate_user

    def index
        @article = Article.find(params[:article_id])
        @revisions = @article.article_revisions.order(created_at: :desc)
    end
    
end
