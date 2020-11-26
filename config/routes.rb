Rails.application.routes.draw do
  root to: "posts#index"
  # 認証
  get    '/login',   to: "sessions#new"
  post   '/login',   to: "sessions#create"
  delete '/logout',  to: "sessions#destroy"

  resources :users, only: %i[ index show new create update destroy]
  namespace :mypage do
    resources :accounts, only: %i[ edit update ]
    resources :activities, only: %i[ index ]
  end
  resources :posts, shallow: true do
    resources :comments
    get :search, on: :collection
  end
  resources :likes, only: %i[ create destroy ]
  resources :relationships, only: %i[ create destroy ]
  resources :activities, only: [] do
    patch :read, on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
