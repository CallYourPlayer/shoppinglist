Rails.application.routes.draw do
  devise_for :users
  root "shoppings#index"
  
  resources :shoppings do 
    resources :items
  end

  post 'shoppings/archive'
  post 'shoppings/search'
  post 'shoppings/search_by_dates'
  post 'items/calculateprice'
  post 'items/paid_item'
  post 'items/set_taken'
  delete 'items/remove'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
