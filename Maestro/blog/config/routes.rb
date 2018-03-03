Rails.application.routes.draw do

  get 'welcome/index'

  devise_for :users, :controllers  => {:registrations => 'registrations'}

  resources :users, only: [:index]

  resources :events do
  	resources :users, only: [:new, :create], path_names: { new: 'add' }
    get 'display' => 'users#display'
    delete 'user_remove/:id' => 'users#remove', as: :delete
  end

  resources :articles do
  	resources :comments
  end

  #resources :inventory

  root 'welcome#index'
end