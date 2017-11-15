module Fserverapi
  class API < Grape::API
    version 'v1', using: :header, vendor: 'twitter'
    format :json
    prefix :api
    desc 'create song request'
    post :create_song do
      status 200
      {}
    end
  end
end