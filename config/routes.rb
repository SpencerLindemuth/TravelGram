Rails.application.routes.draw do
  resources :cities
  resources :locations
  resources :likes
  resources :posts
  get '/travelgram', to: 'users#travelgram', as: "travelgram" 
  get '/', to: 'users#travelgram'
  post '/authenticate', to: "users#authenticate", as: "authenticate"
   
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
