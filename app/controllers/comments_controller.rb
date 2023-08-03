class CommentsController < ApplicationController
    before_action :authenticate_user!

    def create
        @article = Article.find(params[:article_id])
        @comment = @article.comments.new(comment_params)
        @comment.user = current_user

        if @comment.save
        redirect_to @article
        else
        redirect_to @article, alert: 'Failed to create comment.'
        end
    end

    def destroy
        @article = Article.find(params[:article_id])
        @comment = @article.comments.find(params[:id])

        if @comment.destroy
        redirect_to @article
        else
        redirect_to @article, alert: 'Failed to delete comment.'
        end
    end

    private

    def comment_params
        params.permit(:text)
    end
end
