class ArticlesController < ApplicationController

    # def default_url_options
    #     { host: request.base_url }
    # end

    skip_before_action :verify_authenticity_token
    
    

    def new
        @article = Article.new
    end
    
    def create
        # @article = Article.new(article_params)
        
        # puts @article
        # if @article.save
        #     redirect_to article_path(@article)
        # else
        #     render :new
        # end
        @article = Article.new(article_params)
        @article.author_id = current_user.id # Assuming you have access to the current_user method.

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


        @articles = Article.includes(:image_attachment, :likes, :comments, :author)
                            .paginate(page: params[:page], per_page: 10)
    
        # if @articles.empty?
        #     flash.now[:notice] = 'No articles found.'
        # end

        @articles = @articles.map do |article|
            {
            id: article.id,
            title: article.title,
            description: article.description,
            tags: article.tags,
            topic: article.topic,
            likes_count: article.likes.count,
            comments_count: article.comments.count,
            views_count: article.views,
            # author_id: article.author.id,
            # author_name: article.author.name,
            image_url: article.image.attached? ? url_for(article.image) : nil
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
            :title, 
            :description, 
            :tags, 
            :topic,   
            # :likes, 
            # :comments, 
            :author_id,
            # :views , 
            # :search, 
            :image,
            ).merge(
                likes: 0,
                comments: 0,
                views: 0
            )
    end
    
end
