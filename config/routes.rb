Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root 'events#index', as: :authenticated_root
  end

  unauthenticated do
    root 'home#index', as: :unauthenticated_root
  end

  resources :events do
    member do
      get :show_public
    end
  end
end
