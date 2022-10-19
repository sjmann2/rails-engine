Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/items/find?name', to: 'items#search_name'
      # get '/items/find?min_price', to: 'items#search_min_price'

      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, only: [:index], controller: 'item_merchant'
      end

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchant_items'
      end

    end
  end
end
