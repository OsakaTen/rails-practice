Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  # mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # Deviseのルート（ログイン、ユーザー登録など）

  
  # 管理用イベント（ログイン必要）
  resources :events
  
  # 公開用イベント（ログイン不要、トークンでアクセス）
  get 'public/events/:token', to: 'public_events#show', as: 'public_event'

  root 'events#index'

end
