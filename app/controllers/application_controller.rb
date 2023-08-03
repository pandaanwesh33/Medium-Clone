class ApplicationController < ActionController::Base
    before_action :set_default_url_options

    private

    def set_default_url_options
        Rails.application.routes.default_url_options[:host] = request.host_with_port
    end
end
