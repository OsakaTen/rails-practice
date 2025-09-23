Rails.application.routes.draw do
  devise_for :users
  resources :events

  root 'home#index'

end
