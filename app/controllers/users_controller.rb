class UsersController < ApplicationController

    #temporarily using this.....it skips token auth during create...
    #it may also introduce security issues

    # skip_before_action :verify_authenticity_token, only: [:create]
    before_action :authenticate_user!, except: [:index, :show]

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
            # format.html # Render the show.html.erb template by default
            format.json { render json: @user }
        end

      end
    
    #   def new
    #     @user = User.new
    #   end
    
    #   def create
    #     @user = User.new(user_params)
    #     if @user.save
    #       redirect_to @user, notice: 'User was successfully created.'
    #     else
    #       render :new
    #     end
    #   end
    
      def edit
        @user = User.find(params[:id])
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
    
      private
    
      def user_params
        params.permit(
            :name,
            :email, 
            :password,
            :password_confirmation
        )
      end
end
