require 'fileutils'

class RecommendSongController < ApplicationController
  protect_from_forgery with: :null_session
  IS_DEBUGGING = true
  if IS_DEBUGGING
    OUTPUT_TMP_PATH = 'mp3tank_raw_tmp/'.freeze
    OUTPUT_PATH = 'mp3tank_raw/'.freeze
  else
    OUTPUT_TMP_PATH = '/root/mp3tank_raw_tmp/'.freeze
    OUTPUT_PATH = '/root/mp3tank_raw/'.freeze
  end

  def create_song
    youtube_id = params['id']
    return render json: '{error: id empty}', status: 400 unless youtube_id
    YoutubeDL.download "https://www.youtube.com/watch?v=#{youtube_id}", output: OUTPUT_TMP_PATH + youtube_id.to_s
    files = Dir[OUTPUT_TMP_PATH + "#{youtube_id}*"]
    return render json: '{error: many outputs}', status: 400 if files.size != 1
    target_file = files[0]
    FileUtils.mv target_file, OUTPUT_PATH + target_file.split('/').last
    render json: '{}'
  end
end
