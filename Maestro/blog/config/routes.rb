Rails.application.routes.draw do

  get 'welcome/index'

  devise_for :users
  
  resources :users, only: [:index]

  resources :events do
  	resources :users, only: [:new, :create], path_names: { new: 'add' }
    get 'display' => 'users#display'
    delete 'remove' => 'users#remove'
  end

  resources :articles do
  	resources :comments
  end

  #resources :inventory

  root 'welcome#index'
end
