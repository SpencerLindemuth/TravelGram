Rails.application.routes.draw do
  get 'sessions/new'
  resources :cities
  resources :locations
  resources :posts
  # get '/travelgram', to: 'users#travelgram', as: "travelgram" 
  # get '/', to: 'users#travelgram'
  # post '/authenticate', to: "users#authenticate", as: "authenticate"
  resources :posts do
    resources :likes
  end 
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy', as: "logout"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/search', to: 'posts#index', as: 'search'
  root 'sessions#new'
end
