class SavedArticlesController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user

    def create
        @article = Article.find(params[:article_id])
        current_user.saved_articles.create(article: @article)
        redirect_to @article, notice: 'Article saved for later.'
    end
      
    def destroy
        @saved_article = current_user.saved_articles.find_by(article_id: params[:article_id])
        @saved_article.destroy
        redirect_to @saved_article.article, notice: 'Article removed from saved list.'
    end

    def save_for_later_params
        params.permit(
            :article_id
        )
    end
end
