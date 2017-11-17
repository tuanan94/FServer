require 'fileutils'

module Fserverapi
  class API < Grape::API
    IS_DEBUGGING = true
    if IS_DEBUGGING
      OUTPUT_TMP_PATH = 'tmp/mp3tank_raw_tmp/'.freeze
      OUTPUT_PATH = 'tmp/mp3tank_raw/'.freeze
    else
      OUTPUT_TMP_PATH = '/root/mp3tank_raw_tmp/'.freeze
      OUTPUT_PATH = '/root/mp3tank_raw/'.freeze
    end

    before do
      token = params['token']
      @account = Account.find_by(uuid: token)
    end


    version 'v1', using: :header, vendor: 'twitter'
    format :json
    prefix :api
    desc 'create song request'
    post :create_song do
      youtube_id = params['id']

      unless youtube_id
        status 400
        present APIError.new('Youtube_id is missing')
        return
      end
      YoutubeDL.download "https://www.youtube.com/watch?v=#{youtube_id}", output: OUTPUT_TMP_PATH + youtube_id.to_s
      files = Dir[OUTPUT_TMP_PATH + "#{youtube_id}*"]
      if files.size != 1
        status 400
        present APIError.new('Many outputs')
        return
      end
      target_file = files[0]
      FileUtils.mv target_file, OUTPUT_PATH + target_file.split('/').last
      status 200
      {}
    end

    post :create_account do
      name = params['name']
      uuid = SecureRandom.base64(128).to_s.remove('+')
      account = Account.create(uuid: uuid,name: name)
      unless account
          status 400
          present APIError.new('Many outputs')
      end
      status 200
      {token: account.uuid}
    end

    post :set_song_id do
      token = params['token']
      unless token == Constant::LIBSHOUT_TOKEN
        status 400
        present APIError.new('Who are you??')
      end
      id = params["id"]
      base_uri = 'https://fradio-firebase.firebaseio.com/'
      firebase = Firebase::Client.new(base_uri, Constant::FIREBASE_SECRET_KEY)
      # Call to youtube api
      youtube_response = HTTP.get("https://www.googleapis.com/youtube/v3/videos?part=id%2C+snippet&id=#{id}&key=AIzaSyDZaBwBbLqgsNwGaFihdkuiyM3OHpVI64g").to_s
      begin
        title = JSON.parse(youtube_response)["items"][0]["snippet"]["title"]
      rescue => e
        p "Error" + e.to_s
      end
      response = firebase.set("/current",{:id => id, :title => title})
      status 200
      {}
    end
  end
end
