Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :items do
        get '/find', to: 'search#find'
      end

      namespace :merchants do
        get '/find_all', to: 'search#find_all'
      end

      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, only: [:index], controller: 'item_merchant'
      end

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchant_items'
      end
    end
  end
end
