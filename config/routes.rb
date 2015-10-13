Rails.application.routes.draw do
  devise_for :users

  root 'media_items#index'
  resources :items
end
