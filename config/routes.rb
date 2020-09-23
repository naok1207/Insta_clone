Rails.application.routes.draw do
  # 認証
  get    '/login',   to: "sessions#new"
  post   '/login',   to: "sessions#create"
  delete '/logout',  to: "sessions#destroy"

  resources :users, only: %i[ show new create ]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
