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
      single = 'price_1QZZYoBLJNSq80FfONF7Ky7a'
      double = 'price_1Q17JCBLJNSq80FfbnmUr55a'
      mid = 'price_1Q17JCBLJNSq80Ff9Z1B7esg'
      full = 'price_1Q17JCBLJNSq80Ff9gWMLUIn'
      limitless = 'price_1R1FvZBLJNSq80FfCXbatnzQ'
      limitlessNutri = 'price_1R1FyTBLJNSq80FfFRhTtDWV'

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
      elsif session.metadata.key == limitless
        @user.update(
          yogaclass: user_yogaclasses + 99,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == limitlessNutri
        @user.update(
          yogaclass: user_yogaclasses + 99,
          enddate: Time.now + 30.days
        )
      elsif
        @user.update()
      end
    when event.type == 'customer.subscription.updated', 'customer.subscription.created'
      session = event.data.object
      mid = 'price_1R1tZGBLJNSq80Ff7krJ3z7p'
      full = 'price_1R1tZoBLJNSq80FfKCsxQnDe'
      limitless = 'price_1R1taIBLJNSq80FfNUJxp5CV'
      # debugger

      @user = User.find_by(stripe_id: session.customer)
      user_yogaclasses = @user.yogaclass

      if session.metadata.key == mid
        @user.update(
          yogaclass: user_yogaclasses + 8,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == full
        @user.update(
          yogaclass: user_yogaclasses + 12,
          enddate: Time.now + 30.days
        )
      elsif session.metadata.key == full
        @user.update(
          yogaclass: user_yogaclasses + 99,
          enddate: Time.now + 30.days
        )
      end
    end

    render json: { message: 'success' }
  end
end
