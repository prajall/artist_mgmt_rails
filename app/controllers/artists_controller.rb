class ArtistsController < ApplicationController
  include PermissionModule

  before_action -> { authorize_role(%w[super_admin artist_manager]) }, only: [ :create, :index ]
  before_action :set_artist, only: [ :show, :update, :destroy ]
  before_action -> { is_owner(@artist) }, only: [ :update ]
  before_action -> { is_manager(@artist) }, only: [ :update, :destroy ]

  def create
    # Validate manager_id is an artist_manager
    manager = User.find_by(id: artist_params[:manager_id])
    unless manager && manager.role == "artist_manager"
      return render json: { error: "User with this manager id is not an artist manager" }, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      user = User.new(user_params)
      user.role = "artist"
      artist = Artist.new(artist_params)
      artist.user = user
      user.save!
      artist.save!
      
      render json: {
        user: user.slice(:id, :first_name, :last_name, :email, :role, :dob, :gender, :address, :dob), 
        artist: artist
      }, 
      status: :created

    rescue ActiveRecord::RecordInvalid => e
      render json: {error: e.record.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # GET /artists
  def index
    if current_user&.super_admin?
      @artists = Artist.includes(:user, :manager).all
    elsif current_user&.artist_manager?
      @artists = Artist.includes(:user, :manager).where(manager_id: current_user.id)
    else
      render json: { error: "Forbidden" }, status: :forbidden
    end
     render json: @artists.as_json(
      include: {
        user: { only: [ :id, :first_name, :last_name, :email, :role ]}, 
        manager: { only: [ :id, :first_name, :last_name, :email, :role ]}
      }
     )
  end
  
  # GET /artists/1
  def show
    render json: @artist
  end
    
  # POST /artists
  # PATCH/PUT /artists/1
  def update
    if @artist.update(artist_params)
      render json: @artist
    else
      render json: @artist.errors, status: :unprocessable_entity
    end
  end
    
  # DELETE /artists/1
  def destroy
    @artist.destroy!
  end

  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_artist
      @artist = Artist.find(params[:id])
  end
    
    # Only allow a list of trusted parameters through.
    def artist_params
      params.permit(
        :artist_name, 
        :first_release_year, 
        :manager_id
      )
    end

    def user_params
      params.permit(
        :first_name,
        :last_name,
        :email,
        :role,
        :phone,
        :gender,
        :address,
        :dob,
        :password
      )
    end


    
end
