class WebhooksController < ApplicationController
#   skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def create
    Stripe.api_key = Rails.configuration.stripe[:secret_key]
    webhook_key = Rails.configuration.stripe[:webhook_key]

    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, webhook_key
      )
    rescue JSON::ParserError => e
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts "Signature error"
      p e
      return
    end

    # Handle the event
    case event.type
    when 'customer.created'
      customer = event.data.object
      @user = User.find_by(email: customer.email)
      @user.update(stripe_id: customer.id)
    when 'checkout.session.completed'
      session = event.data.object
      prices = Rails.configuration.stripe[:prices]

      @user = User.find_by(stripe_id: session.customer)
      user_yogaclasses = @user.yogaclass

      if session.metadata.key == prices[:single]
        @user.update(
          yogaclass: user_yogaclasses + 1,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == prices[:double]
        @user.update(
          yogaclass: user_yogaclasses + 4,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == prices[:mid]
        @user.update(
          yogaclass: user_yogaclasses + 8,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == prices[:full]
        @user.update(
          yogaclass: user_yogaclasses + 12,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == prices[:limitless]
        @user.update(
          yogaclass: user_yogaclasses + 99,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == prices[:limitless_nutri]
        @user.update(
          yogaclass: user_yogaclasses + 99,
          enddate: Time.now + 30.days
        )
      elsif
        @user.update()
      end
    when event.type == 'customer.subscription.updated', 'customer.subscription.created'
      session = event.data.object
      recurring_prices = Rails.configuration.stripe[:recurring_prices]
      # debugger

      @user = User.find_by(stripe_id: session.customer)
      user_yogaclasses = @user.yogaclass

      if session.metadata.key == recurring_prices[:mid]
        @user.update(
          yogaclass: user_yogaclasses + 8,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == recurring_prices[:full]
        @user.update(
          yogaclass: user_yogaclasses + 12,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == recurring_prices[:limitless]
        @user.update(
          yogaclass: user_yogaclasses + 99,
          enddate: Time.now + 30.days
        )
      end
    end

    render json: { message: 'success' }
  end
end
