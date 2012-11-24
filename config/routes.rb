Freemark::Application.routes.draw do
  resources :tags
  resources :taggings
  resources :bmarks

  devise_for :users

  get "home/index"
  match "import" => "home#get"
  match "upload" => "home#save"

  root to: "home#index"
end
