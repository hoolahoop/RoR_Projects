Rails.application.routes.draw do

  get 'welcome/index'

  devise_for :users, :controllers  => {:registrations => 'registrations'}

  resources :users, only: [:index]

  resources :events do
    get 'display' => 'events#display'
    get 'add' => 'events#add'
    post 'make' => 'events#make'
    delete 'user_remove/:id' => 'events#remove', as: :delete
  end

  resources :articles do
  	resources :comments
  end

  #resources :inventory

  root 'welcome#index'
end