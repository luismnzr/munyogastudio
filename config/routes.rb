Rails.application.routes.draw do
  namespace :admin do
      resources :users
      resources :class_sessions

      root to: "users#index"
    end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'pages#home'
  get 'calendario', to: 'pages#calendario'

  resources :reservations, only: [:index, :create, :destroy]

  get 'payments/new'
  post 'payments/create', to: 'payments#create', as: 'payments_create'
  post 'payments/recurring', to: 'payments#recurring', as: 'payments_recurring'
  get 'payments/success'
  get 'payments/cancel'
  resources :webhooks, only: [:create]
  post "billing_portal/create", to: "billing_portal#create", as: "billing_portal_create"

end
