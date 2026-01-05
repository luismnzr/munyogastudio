Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISH_KEY'],
  secret_key: ENV['STRIPE_SECRET_KEY'],
  webhook_key: ENV['WEBHOOK_KEY'],

  # One-time payment price IDs
  prices: {
    single: ENV['STRIPE_PRICE_SINGLE'],
    double: ENV['STRIPE_PRICE_DOUBLE'],
    mid: ENV['STRIPE_PRICE_MID'],
    full: ENV['STRIPE_PRICE_FULL'],
    limitless: ENV['STRIPE_PRICE_LIMITLESS'],
    limitless_nutri: ENV['STRIPE_PRICE_LIMITLESS_NUTRI']
  },

  # Recurring payment price IDs
  recurring_prices: {
    mid: ENV['STRIPE_RECURRING_PRICE_MID'],
    full: ENV['STRIPE_RECURRING_PRICE_FULL'],
    limitless: ENV['STRIPE_RECURRING_PRICE_LIMITLESS']
  }
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]