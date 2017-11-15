require 'fileutils'

module Fserverapi
  class API < Grape::API
    IS_DEBUGGING = true
    if IS_DEBUGGING
      OUTPUT_TMP_PATH = 'mp3tank_raw_tmp/'.freeze
      OUTPUT_PATH = 'mp3tank_raw/'.freeze
    else
      OUTPUT_TMP_PATH = '/root/mp3tank_raw_tmp/'.freeze
      OUTPUT_PATH = '/root/mp3tank_raw/'.freeze
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
      return render json: '{error: many outputs}', status: 400 if files.size != 1
      target_file = files[0]
      FileUtils.mv target_file, OUTPUT_PATH + target_file.split('/').last

      render json: '{}'
      status 200
      {}
    end
  end
end
