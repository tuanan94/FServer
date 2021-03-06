Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'create_song' => 'recommend_song#create_song'
  get 'extend/request_waiting'
  get 'extend/app_name'

  mount Fserverapi::API => '/'
end
