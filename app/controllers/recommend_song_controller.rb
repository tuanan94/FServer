class RecommendSongController < ApplicationController
  protect_from_forgery with: :null_session

  def create_song
    youtube_id = params["id"]
    return render :json => "{error: id empty}", :status => 400 unless youtube_id
    YoutubeDL.download "https://www.youtube.com/watch?v=#{youtube_id}", output: "/root/mp3tank_raw/#{youtube_id}"
    render :json => "{}"
  end
end
