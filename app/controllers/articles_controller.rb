class ArticlesController < ApplicationController

    # def default_url_options
    #     { host: request.base_url }
    # end

    # because, when using JWT for authentication, CSRF protection is not required
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user, except: [:index]
    

    def new
        @article = Article.new
    end
    
    def create

        @article = Article.new(article_params)
        @article.author_id = current_user.id

        if params[:commit] == 'Save as Draft'
            @article.published = false
        end

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

        if params[:commit] == 'Save as Draft'
            @article.published = false
        end

        if @article.update(article_params)
            ArticleRevision.create(
                article: @article,
                title: @article.title,
                content: @article.content,
                user: current_user
            )
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
        current_user.increment!(:daily_article_visit_count) if current_user
        

        # finds allowed article visits as per subscription and 
        # no of articles user has visited on a day
        allowed_article_visits = @current_user.subscription_plan.daily_article_limit
        user_daily_visits = @current_user.article_visits.where("visited_at >= ?", Time.zone.now.beginning_of_day).count

        # Check if the current user has liked the article
        is_liked = false
        if @current_user # Assuming you are using Devise or similar authentication gem
            is_liked = @article.likes.exists?(user_id: current_user.id)
        end

        estimated_reading_time = @article.reading_time

        #finding 5 posts by same author
        @author = @article.user
        @similar_posts = Article.where(user: @author)
                        .where.not(id: @article.id)
                        .limit(5)

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
            reading_time: estimated_reading_time,
            image: @article.image,
            similar_posts: @similar_posts
            # is_saved: is_saved   #not yet implemented
        }

        #if view limit exists then only send article
        if user_daily_visits < allowed_article_visits
            # Create an ArticleVisit record to track the visit
            ArticleVisit.create(user: current_user, article: @article, visited_at: Time.now)
            # if current_user&.can_view_article?
                respond_to do |format|
                    # format.html # Render the show.html.erb template by default
                    format.json { render json: @article_data }
                end
        else
            render json: { error: 'Daily limit exceeded for your subscription plan.' }, status: :unprocessable_entity
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
            # topic: article.topic,
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

    def top_posts
        weight_likes = 1
        weight_comments = 2
        weight_visits = 0.5
    
        @top_posts = Article.all.sort_by do |article|
          calculate_rank(article, weight_likes, weight_comments, weight_visits)
        end.reverse.take(10)

        return @top_posts
    end

    #for now only likes are considered
    #extracted liked articles and found similarity index
    def recommendations
        user = @current_user
        liked_articles = user.liked_articles
    
        all_articles = Article.all
    
        recommended_articles = all_articles.sort_by do |article|
          similarity = 0
          liked_articles.each do |liked_article|
            similarity += calculate_similarity(article, liked_article)
          end
          -similarity
        end
    
        @recommended_articles = recommended_articles.take(5)
    end

    private

    def article_params
        params.permit(
            :id,
            :title, 
            :description,  
            :image,
            # filters
            :author,
            :date,
            :sort_order,
            :page,
            :top_posts
            )
    end

    def can_view_article?
        # return true if subscription_plan.name == 'Free'
        daily_article_visit_count < subscription_plan.daily_article_limit
    end

    def calculate_rank(article, weight_likes, weight_comments, weight_visits)
        (weight_likes * article.likes.count) +
        (weight_comments * article.comments.count) +
        (weight_visits * article.article_visits.count)
    end

    #for recommendation
    #calculate the similarity between articles based on their tags
    def calculate_similarity(article1, article2)
        tags1 = article1.tags
        tags2 = article2.tags
      
        intersection = tags1 & tags2
        union = tags1 | tags2
      
        intersection.size.to_f / union.size
    end
    

end
