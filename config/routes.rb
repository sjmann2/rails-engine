Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, only: [:index], controller: 'item_merchant'
      end

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index] #could direct this to controller: 'merchant_items'
      end
    end
  end
end
