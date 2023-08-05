class AuthController < ApplicationController
    # skip_before_action :verify_authenticity_token, only: [:login]
    # def login
    #     user = User.find_by(email: params[:email])
    
    #     if user&.authenticate(params[:password])
    #       token = encode_token({ user_id: user.id })
    #       render json: { token: token }
    #     else
    #       render json: { error: 'Invalid credentials' }, status: :unauthorized
    #     end
    #   end
    
    #   private
    
    #   def encode_token(payload)
    #     JWT.encode(payload, ENV['JWT_SECRET_KEY'])
    #   end
end
