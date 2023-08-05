class FollowsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user

    
    def create
        @user = User.find(params[:id])
        current_user.follows.create(follower: @user) unless current_user.following?(@user)
        redirect_to @user
      end
    
      def destroy
        @user = User.find(params[:id])
        follow = current_user.follows.find_by(follower: @user)
        follow.destroy if follow
        redirect_to @user
      end

    
    private

    def follows_params
        params.permit(:id)
    end

    def following?(other_user)
        follows.include?(other_user)
    end
end
