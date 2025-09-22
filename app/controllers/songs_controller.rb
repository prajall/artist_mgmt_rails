class SongsController < ApplicationController
  include PermissionModule
  before_action :set_song, only: %i[ show update destroy ]
  before_action -> { owner(@song.artist) }, only: %i[show update destroy]
  before_action -> {authorize_role(%w[artist])}, except: %i[index]

  # GET /songs
  def index
    if current_user.role == "artist"
      @songs = Song.includes(:artist)
        .where(artist: current_artist)
        .page(params[:page])
        .per(params[:limit])
    elsif current_user.role == "artist_manager"
      @songs = Song.includes(:artist)
        .joins(:artist)
        .where(artists: {manager_id: current_user.id})
        .page(params[:page])
        .per(params[:limit])
    else
      @songs = Song.includes(:artist)
        .page(params[:page])
        .per(params[:limit])
    end
    render json: @songs.as_json(
      include: { 
        artist: {only: [:artist_name, :id, :first_release_year, :no_of_albums_released]}
      }
    )
  end

  # GET /songs/1
  def show
    render json: @song
  end

  # POST /songs
  def create
    @song = Song.new(song_params)

    unless current_user.role == "super_admin"
      @song.artist = current_user.artist
    else
      if !params[:artist]
        return render json: {error: "Artist is required"}
      end
      begin
        artist = Artist.find(params[:artist])
      rescue ActiveRecord::RecordNotFound  
        return render json: {error: "Invalid Artist Id"}
      end
      @song.artist = artist
    end
    
    if @song.save
      render json: @song, status: :created, location: @song
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /songs/1
  def update
    if @song.update(song_params)
      render json: @song
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  # DELETE /songs/1
  def destroy
    @song.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params.require(:id))
    end

    # Only allow a list of trusted parameters through.
    def song_params
      params.permit(:title, :genre)
    end
end
