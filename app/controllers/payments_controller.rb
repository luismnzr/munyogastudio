class PaymentsController < ApplicationController
  def new
  end

  def create
    @session = Stripe::Checkout::Session.create({
      customer: if current_user.stripe_id?
                    Stripe::Customer.retrieve(current_user.stripe_id)
                  else
                    Stripe::Customer.create(email: current_user.email)
                  end,
      success_url: 'hhttps://munyogastudio.com/users/edit',
      cancel_url: 'https://munyogastudio.com/payments/new',
      line_items: [
        {price: params[:plan_id], quantity: 1},
      ],
      mode: 'payment',
      allow_promotion_codes: true,
      metadata: {key: params[:plan_id]},
      # subscription_data: [
      #   {trial_end: 604800},
      # ],
    })
    redirect_to @session.url, allow_other_host: true
    # respond_to do |format|
    #   format.js
    # end
  end
  
  def success
    #handle successful payments
    redirect_to root_url, notice: "Purchase Successful"
  end
  
  def cancel
    #handle if the payment is cancelled
    redirect_to root_url, notice: "Purchase Unsuccessful"
  end
end