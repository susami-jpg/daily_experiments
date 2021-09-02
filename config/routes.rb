Rails.application.routes.draw do
  resources :experiment_records
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  namespace :admin do
    resources :users
  end
  root to: 'tasks#index'
  resources :tasks
end
