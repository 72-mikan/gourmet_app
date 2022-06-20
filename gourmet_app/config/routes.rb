Rails.application.routes.draw do
  devise_for :users
  root :to => "shop#index"
  get '/shop/index' => 'shop#index'
  resources :users, only: [:show, :edit, :update]
  resources :shop, only: [:show] do
    resource :favorites, only: [:create, :destroy]
  end
end
