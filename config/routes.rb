Rails.application.routes.draw do
  resources :styles
  resources :memberships
  resources :beer_clubs
  resources :beers
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :places, only: [:index, :show]
  resource :session, only: [:new, :create, :destroy]

  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :users do
    post 'toggle_closed', on: :member
  end

  get 'kaikki_bisset', to: 'beers#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'
  delete 'signout', to: 'sessions#destroy'

  # mikä generoi samat polut kuin seuraavat kaksi
  # get 'places', to:'places#index'
  # get 'places/:id', to:'places#show'

  post 'places', to:'places#search'

  post 'close/:id', to: 'users#close'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'breweries#index'
end
