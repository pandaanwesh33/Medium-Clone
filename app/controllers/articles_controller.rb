class ArticlesController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def default_url_options
        { host: request.base_url }
    end

    def new
        @article = Article.new
    end
    
    def create
        @article = Article.new(article_params)
        
        # puts @article
        if @article.save
            redirect_to article_path(@article)
        else
            render :new
        end
    end

    # Other actions like edit, update, destroy, index, show, etc.
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
        # handles different types of requeste
        # if request is from Web browser (i.e HTML -> renders show.html.erb)
        # else for API request(e.g from postman -> renders json)
        respond_to do |format|
            # format.html # Render the show.html.erb template by default
            format.json { render json: @article }
        end
    end
        
    
    def index

        @articles = Article.where(nil)
        
        if params[:author].present?
            @articles = @articles.where(author: params[:author])
        end
        if params[:start_date].present?
            @articles = @articles.where('publish_date >= ?', params[:start_date]) 
        end
        if params[:end_date].present?
            @articles = @articles.where('publish_date <= ?', params[:end_date]) 
        end

        if params[:search].present?
            @articles = @articles.where('title LIKE ?', "%#{params[:search]}%") 
        end
        if params[:search].present?
            @articles = @articles.where('description LIKE ?', "%#{params[:search]}%") if params[:search].present?
        end
        if params[:search].present?
            @articles = @articles.where('tags LIKE ?', "%#{params[:search]}%") if params[:search].present?
        end
        # @articles = nil
        per_page = params[:per_page] || 10
        @articles = Article.paginate(page: params[:page], per_page: per_page)     
    end

    

    #   def index
    #     @articles = Article.order(publish_date: params[:sort] == 'desc' ? :desc : :asc)
    #                        .paginate(page: params[:page], per_page: 10)
    #   end

    private

    def article_params
        params.permit(:title, :description, :tags, :author, :publish_date, :search, :image)
    end
end
