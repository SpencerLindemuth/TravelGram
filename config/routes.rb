Rails.application.routes.draw do
  get 'sessions/new'
  resources :cities
  resources :locations
  resources :likes
  resources :posts
  # get '/travelgram', to: 'users#travelgram', as: "travelgram" 
  # get '/', to: 'users#travelgram'
  # post '/authenticate', to: "users#authenticate", as: "authenticate"
   
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
