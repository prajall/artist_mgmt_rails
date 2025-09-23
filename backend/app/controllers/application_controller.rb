class ApplicationController < ActionController::API
  include ActionController::Cookies

  before_action :authorize_request, :validate_pagination
  attr_accessor :current_user, :current_artist

  # rescue_from StandardError, with: :handle_internal_server_error
  
  def validate_pagination
    page  = params[:page].to_i
    limit = params[:limit].to_i

    page  = page.positive?  ? page  : 1
    limit = limit.positive? ? limit : 12

    params[:page]  = page.clamp(1, 99999)
    params[:limit] = limit.clamp(1, 100)
  end

  def authorize_request
    access_token = cookies.signed[:access_token]
    decoded = JsonWebToken.decode(access_token)
    @current_user = User.find_by(id: decoded["id"]) if decoded 
    puts "Current user: #{current_user.id} #{current_user.email} #{current_user.role}" if current_user 

    unless @current_user
      return render json: { error: "Unauthorized" }, status: :unauthorized  
    end

    if current_user.role=="artist"
      @current_artist = Artist.find_by(user: current_user)
      unless @current_artist
        return render json: {error: "Artist record not found for current user "}, status: :not_found
      end
    end
  end

  def handle_internal_server_error(exception)    
    puts "----------Server Error-------------"
    puts exception
    render json: { error: "Internal Server Error" }, status: :internal_server_error
  end
end
