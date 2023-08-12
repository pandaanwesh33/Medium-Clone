class ArticlesController < ApplicationController

    # def default_url_options
    #     { host: request.base_url }
    # end

    # because, when using JWT for authentication, CSRF protection is not required
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user, except: [:index, :show]
    

    def new
        @article = Article.new
    end
    
    def create

        @article = Article.new(article_params)
        @article.author_id = current_user.id

        if @article.save
            redirect_to article_path(@article)
        else
            render :new
        end
    end

    def edit
        @article = Article.find(params[:id])
    end

    def update
        @article = Article.find(params[:id])
        if @article.update(article_params)
            redirect_to article_path(@article)
        else
            render :edit
        end
    end

    def destroy
        @article = Article.find(params[:id])
        @article.destroy
        redirect_to articles_path
    end

    def show
        @article = Article.find(params[:id])
        # Check if the current user has liked the article
        is_liked = false
        if @current_user # Assuming you are using Devise or similar authentication gem
            is_liked = @article.likes.exists?(user_id: current_user.id)
        end

        @article_data = {
            id: @article.id,
            title: @article.title,
            description: @article.description,
            tags: @article.tags,
            topic: @article.topic,
            likes_count: @article.likes.count,
            comments_count: @article.comments.count,
            views_count: @article.views,
            created_at: @article.created_at,
            author_id: @article.author.id,
            author_name: @article.author.name,
            # image_url: @article.image.attached? ? url_for(@article.image) : nil,
            comments: @article.comments.map { |comment| { text: comment.text, author_id: comment.user.id, author_name: comment.user.name } },
            is_liked: is_liked,
            image: @article.image
            # is_saved: is_saved   #not yet implemented
        }

        # handles different types of requests
        # if the request is from a web browser (i.e., HTML -> renders show.html.erb)
        # else for API request (e.g., from Postman -> renders JSON)
        respond_to do |format|
            # format.html # Render the show.html.erb template by default
            format.json { render json: @article_data }
        end
    end
        
    
    def index
        @articles = Article.includes( :likes, :comments, :author)
    
         # Filter by author
        if params[:author].present?
            author = User.find_by(name: params[:author])
            @articles = @articles.where(author: author) if author
        end
    
        # Filter by date
        if params[:date].present?
            date = Date.parse(params[:date])
            @articles = @articles.where(created_at: date.beginning_of_day..date.end_of_day) if date
        end
    
        # Sort by number of likes or comments
        #sorted in desc order
        if params[:sort_order].present? && %w[likes comments].include?(params[:sort_order])
            @articles = @articles.left_joins(params[:sort_order].to_sym)
                            .group(:id)
                            .order("COUNT(#{params[:sort_order]}.id) DESC")
        end
    
        @articles = @articles.paginate(page: params[:page], per_page: 10)
        if params[:top_posts].present?
            @articles = Article.all.order('(likes.count + comments.count) DESC')
        end
        @articles = @articles.map do |article|
        {
            id: article.id,
            title: article.title,
            # description: article.description,
            tags: article.tags,
            topic: article.topic,
            likes_count: article.likes.count,
            comments_count: article.comments.count,
            views_count: article.views,
            author_id: article.author.id,
            author_name: article.author.name,
            # image_url: article.image.attached? ? url_for(article.image) : nil,
            image: article.image,
            created_at: article.created_at
        }
        end
    
        respond_to do |format|
        #   format.html # Render the index.html.erb template by default
            format.json { render json: @articles }
        end
            
    end


    private

    def article_params
        params.permit(
            :id,
            :title, 
            :description,  
            :topic,   
            :image,
            # filters
            :author,
            :date,
            :sort_order,
            :page,
            :top_posts
            )
    end
    
end
