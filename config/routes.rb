Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      post "login", to: "auth#login"
      post "register", to: "auth#register"
      delete "logout", to: "auth#logout"


      resources :quick_notes, only: [ :index, :create, :show, :update, :destroy ]
      resources :notebooks, only: [ :index, :create, :show, :update, :destroy ] do
        resources :notes, only: [ :index, :create, :show, :update, :destroy ]
      end
    end
  end
end
