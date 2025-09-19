class ApplicationController < ActionController::API
  include ActionController::Cookies

  before_action :authorize_request, :validate_pagination
  attr_accessor :current_user

  rescue_from StandardError, with: :handle_internal_server_error

  def validate_pagination
    page  = params[:page].to_i
    limit = params[:limit].to_i

    page  = page.positive?  ? page  : 1
    limit = limit.positive? ? limit : 12

    params[:page]  = page.clamp(1, 99999)
    params[:limit] = limit.clamp(1, 100)

    puts "======================================================="
    puts "Page: #{params[:page]} (#{params[:page].class})  Limit: #{params[:limit]} (#{params[:limit].class})"
    puts "======================================================="
  end

  def authorize_request
    access_token = cookies.signed[:access_token]
    decoded = JsonWebToken.decode(access_token)
    @current_user = User.find_by(id: decoded["id"]) if decoded 
     puts "Current user: #{current_user.id} #{current_user.email} #{current_user.role}" if current_user 
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end

  def validate_image(image)
     
  end

  def handle_internal_server_error(exception)    
    puts "----------Server Error-------------"
    puts exception
    render json: { error: "Internal Server Error" }, status: :internal_server_error
  end
end
