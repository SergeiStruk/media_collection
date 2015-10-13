Rails.application.routes.draw do
  devise_for :users

  root 'media_items#index'
  resources :media_items, except: %i[show edit update]
end
