class LikesController < ApplicationController
    before_action :authenticate_user!

  def create
    @article = Article.find(params[:article_id])
    current_user.likes.create(article: @article)
    redirect_to @article
  end

  def destroy
    @article = Like.find(params[:id]).article
    current_user.likes.find_by(article: @article).destroy
    redirect_to @article
  end
end
