Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :orders, only: %i[index show create]
      resources :users, only: %i[show create update destroy]
      resources :tokens, only: [:create]
      resources :products
    end
  end
end
