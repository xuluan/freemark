Freemark::Application.routes.draw do
  resources :bmarks

  devise_for :users

  get "home/index"
  root to: "home#index"
end
