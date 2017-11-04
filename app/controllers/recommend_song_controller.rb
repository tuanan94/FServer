require 'fileutils'

class RecommendSongController < ApplicationController
  protect_from_forgery with: :null_session
  OUTPUT_TMP_PATH = "/root/mp3tank_raw_tmp/"
  OUTPUT_PATH = "/root/mp3tank_raw/"
  def create_song
    youtube_id = params["id"]
    return render :json => "{error: id empty}", :status => 400 unless youtube_id
    YoutubeDL.download "https://www.youtube.com/watch?v=#{youtube_id}", output: OUTPUT_TMP_PATH + "#{youtube_id}"
    files = Dir[OUTPUT_TMP_PATH+"#{youtube_id}*"]
    if (files.size != 1)
      return render :json => "{error: many outputs}", :status => 400
    end
    target_file = files[0]
    FileUtils.mv target_file, OUTPUT_PATH + target_file.split("/").last

    render :json => "{}"
  end
end
