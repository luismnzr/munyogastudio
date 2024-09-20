class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']

    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV['WEBHOOK_KEY']
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
    when 'customer.create'
      customer = event.data.object
      @user = User.find_by(email: customer.email)
      @user.update(stripe_id: customer.id)
    when 'checkout.session.completed'
      session = event.data.object
      single = 'price_1Q17JCBLJNSq80FfINZtLdFh'
      double = 'price_1Q17JCBLJNSq80FfbnmUr55a'
      mid = 'price_1Q17JCBLJNSq80Ff9Z1B7esg'
      full = 'price_1Q17JCBLJNSq80Ff9gWMLUIn'

      @user = User.find_by(stripe_id: session.customer)
      user_yogaclasses = @user.yogaclass

      if session.metadata.key == single
        @user.update(
          yogaclass: user_yogaclasses + 1,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == double
        @user.update(
          yogaclass: user_yogaclasses + 4,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == mid
        @user.update(
          yogaclass: user_yogaclasses + 8,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == full
        @user.update(
          yogaclass: user_yogaclasses + 12,
          enddate: Time.now + 30.days
        )
      elsif
        @user.update()
      end
    end

    render json: { message: 'success' }
  end
end
