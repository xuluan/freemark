Freemark::Application.routes.draw do
  resources :tags

  resources :bmarks

  devise_for :users

  get "home/index"
  root to: "home#index"
end
