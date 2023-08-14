class ArticleRevisionsController < ApplicationController

    skip_before_action :verify_authenticity_token
    before_action :authenticate_user

    def index
        @article = Article.find(params[:article_id])
        @revisions = @article.article_revisions.order(created_at: :desc)
    end

    def revert_to_revision
        @article = Article.find(params[:article_id])
        @revision = @article.article_revisions.find(params[:revision_id])
        
        @article.update(description: @revision.description)
        redirect_to @article, notice: 'Article reverted to a previous version.'
    end

    private

    def article_params
        params.permit(
            :article_id,
            :revision_id
        )
    end
    
end
