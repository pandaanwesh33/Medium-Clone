class TopicsController < ApplicationController
    def index
        @topics = Topic.all
    end
    
    def show
        @topic = Topic.find(params[:id])
        @articles = @topic.articles
    end

    private
    
    def topics_params
        params.permit(
            :id
    end


end
