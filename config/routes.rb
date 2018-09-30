Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  root 'breweries#index'
  resources :beers
  resources :breweries
  get 'kaikki_bisset', to: 'beers#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  resource :session, only: [:new, :create, :destroy]
  resources :ratings, only: [:index, :new, :create]
  resources :ratings, only: [:index, :new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
