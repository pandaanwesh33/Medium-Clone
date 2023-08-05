class ApplicationController < ActionController::Base
    
    before_action :set_default_url_options
    before_action :authenticate_user

    def authenticate_user
        token = request.headers['Authorization']&.split(' ')&.last
        begin
        decoded_token = JWT.decode(token, jwt_secret_key, true, algorithm: 'HS256')
        user_id = decoded_token.first['user_id']
        @current_user = User.find(user_id)
        rescue JWT::DecodeError, JWT::VerificationError, ActiveRecord::RecordNotFound
        render json: { error: 'Invalid or missing token' }, status: :unauthorized
        end
    end

    # Define the current_user method to be used in child controllers
    def current_user
        @current_user
    end
    
    private
    
    def jwt_secret_key
        ENV['JWT_SECRET_KEY']
    end


    

    def set_default_url_options
        Rails.application.routes.default_url_options[:host] = request.host_with_port
    end
    # # Devise Actions

    # def after_sign_in_path_for(resource)
    #     # Redirect to the path you want after a user signs in
    #     # For example, you can redirect to the root path:
    #     root_path
    # end

    # def after_sign_up_path_for(resource)
    #     # Redirect to the path you want after a user signs up
    #     # For example, you can redirect to the root path:
    #     root_path
    # end

    # def after_resetting_password_path_for(resource)
    #     # Redirect to the path you want after a user resets their password
    #     # For example, you can redirect to the login path:
    #     new_user_session_path
    # end

    

end
