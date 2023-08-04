class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token, only: [:create]
    before_action :set_default_url_options




    # Devise Actions

    def after_sign_in_path_for(resource)
        # Redirect to the path you want after a user signs in
        # For example, you can redirect to the root path:
        root_path
    end

    def after_sign_up_path_for(resource)
        # Redirect to the path you want after a user signs up
        # For example, you can redirect to the root path:
        root_path
    end

    def after_resetting_password_path_for(resource)
        # Redirect to the path you want after a user resets their password
        # For example, you can redirect to the login path:
        new_user_session_path
    end

    private

    def set_default_url_options
        Rails.application.routes.default_url_options[:host] = request.host_with_port
    end

end
