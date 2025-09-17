Rails.application.routes.draw do
  resources :artists
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # USERS
  post "/user", to: "users#create"
  post "/login", to: "auth#login"
  get "/profile", to: "users#profile"
end
