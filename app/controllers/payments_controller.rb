class PaymentsController < ApplicationController

    skip_before_action :verify_authenticity_token
    before_action :authenticate_user

    def new
    end
  
    def create
        # Use the Stripe gem to create a payment
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    
        #   token = params[:stripeToken]
        token = 'tok_visa'
        # amount = 1000  # Amount in cents
        amount = params[:amount]

        charge = Stripe::PaymentIntent.create({
            amount: amount,
            currency: 'usd',
            description: 'Example Charge',
            payment_method: 'pm_card_visa',
            # source: token
        })
    

        flash[:success] = "Payment successful!"
        if charge.status == 'requires_confirmation'
            new_plan = SubscriptionPlan.find_by("price": charge.amount)
            @current_user.update(subscription_plan_id: new_plan.id) # Update the subscription_plan attribute
            @current_user.subscription_plan_id = new_plan.id
            @current_user.save
        end
        redirect_to '/users' 
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
