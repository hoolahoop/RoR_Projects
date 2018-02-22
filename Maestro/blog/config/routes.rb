Rails.application.routes.draw do

  get 'welcome/index'

  devise_for :users
  
  resources :users, :only => [:index]

  resources :events

  resources :articles do
  	resources :comments
  end

  #resources :inventory

  root 'welcome#index'
end
