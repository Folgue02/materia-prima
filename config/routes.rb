Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"

  get    "login",  to: "sessions#new",     as: :login
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  resources :users

  resources :food_funds do
    resource  :subscription, only: %i[create destroy]
    resources :spendings,    only: %i[new create]
  end
end
