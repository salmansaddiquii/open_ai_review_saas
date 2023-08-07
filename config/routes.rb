Rails.application.routes.draw do
  root to: "homes#index"
  
  devise_for :users
  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :users do
        collection do 
          post :forgot_password
          post :reset_password
          put :change_password
        end
      end
      post '/auth/login', to: 'authentication#login'
      put '/auth/logout', to: 'authentication#logout'

      resources :reviews
    end
  end
end
