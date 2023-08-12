class UsersController < ApplicationController

    #temporarily using this.....it skips token auth during create...
    #it may also introduce security issues
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user, except: [:index, :new, :create, :login]

    def index
        @users = User.all

        respond_to do |format|
            # format.html # Render the show.html.erb template by default
            format.json { render json: @users }
        end
      end
    
      def show
        @user = User.find(params[:id])
      
        respond_to do |format|
          format.json do
            render json: {
              id: @user.id,
              name: @user.name,
              about: @user.about,
              email: @user.email,
              image: @user.image, 
              followers: @user.followers.map { |follower| { id: follower.id, name: follower.name, photo: follower.image } },
              followings: @user.followed_users.map { |following| { id: following.id, name: following.name, photo: following.image } },
              is_followed: current_user.following?(@user),
              is_following: @user.following?(current_user)
            }
          end
         
        end
        
        # respond_to do |format|
            # format.html # Render the show.html.erb template by default
            # format.json { render json: @user }
        # end

      end
    
      def new
        @user = User.new
      end
    
      
      def create
        @user = User.new(user_params)
        if @user.save
          # token = encode_token({ user_id: user.id })
          render json: @user, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    
      def edit
        @user = User.find(params[:id])

    respond_to do |format|
      # format.html 
      format.json do
        render json: {
          id: @user.id,
          name: @user.name,
          email: @user.email,
          password: '', #not sending password due to security reason
          about: @user.about,
          photo: @user.image
        }
      end
    end
      end
    
      def update
        @user = User.find(params[:id])
        if @user.update(user_params)
          redirect_to @user, notice: 'User was successfully updated.'
        else
          render :edit
        end
      end
    
      def destroy
        @user = User.find(params[:id])
        @user.destroy
        redirect_to users_url, notice: 'User was successfully destroyed.'
      end

      def login
        @user = User.find_by(email: params[:email])
        puts @user
        if @user&.authenticate(params[:password])
          token = generate_jwt_token(@user)
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end
    
      private
    
      def user_params
        params.permit(:image, :name, :email, :password)
      end

      def generate_jwt_token(user)
        payload = { user_id: user.id }
        JWT.encode(payload, jwt_secret_key, 'HS256')
      end
      
      def jwt_secret_key
        ENV['JWT_SECRET_KEY']
      end

      def following?(other_user)
        followed_users.include?(other_user)
      end
end
