class ListsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user
    
    def index
        @lists = @current_user.lists
    end

    def show
        @list = @current_user.lists.find(params[:id])
    end

    def share
        @list = current_user.lists.find(params[:id])
        @shareable_link = generate_shareable_link(@list)
        UserMailer.share_list_email(current_user, @list, @shareable_link).deliver_now
        redirect_to list_path(@list), notice: 'List shared successfully!'
    end

    private

    def generate_shareable_link(list)
        token = SecureRandom.hex(16)
        list_share_url(token: token)
    end
end
