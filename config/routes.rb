Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants/search#find'
      get '/items/find_all', to: 'items/search#find_all'
      resources :merchants, only: [:index, :show]
      resources :items, except: [:new, :edit]
    end
  end
end
