Rails.application.routes.draw do
  namespace :admin do
      resources :users

      root to: "users#index"
    end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'pages#home'
  get 'calendario', to: 'pages#calendario'
  get 'payments/new'
  post 'payments/create', to: 'payments#create', as: 'payments_create'
  get 'payments/success'
  get 'payments/cancel'
  resources :webhooks, only: [:create]
  post 'billing_portal', to: 'billing_portal#create'

end
