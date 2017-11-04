class RecommendSongController < ApplicationController
  protect_from_forgery with: :null_session

  def create_song
    render :json => "{}"
  end
end
