Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'create_song' => 'recommend_song#create_song'
  mount Fserverapi::API => '/'

end
