class FollowsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user

    
    def create
        if current_user.nil?
            puts current_user
        else
            @user = User.find(params[:id])
            current_user.followees << @user
            redirect_back(fallback_location: user_path(@user))
        end
    end
      
    def destroy
    @user = User.find(params[:id])
    current_user.followed_users.find_by(followee_id: @user.id).destroy
    redirect_back(fallback_location: user_path(@user))
    end
    
    private

    def follows_params
        params.permit(:id)
    end

    # def following?(other_user)
    #     follows.include?(other_user)
    # end
end
