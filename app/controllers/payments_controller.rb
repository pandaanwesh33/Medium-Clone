class PaymentsController < ApplicationController

    skip_before_action :verify_authenticity_token

    def new
    end
  
    def create
        # Use the Stripe gem to create a payment
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    
        #   token = params[:stripeToken]
        token = 'tok_visa'
        amount = 1000  # Amount in cents
    
        charge = Stripe::PaymentIntent.create({
            amount: amount,
            currency: 'usd',
            description: 'Example Charge',
            payment_method: 'pm_card_visa',
            # source: token
        })
    
        flash[:success] = "Payment successful!"
        redirect_to '/articles'
        rescue Stripe::CardError => e
        flash[:error] = e.message
        render :new
    end

    private

    def payment_params
        params.permit(
            :stripeToken,
            :amount
            )
    end
end
