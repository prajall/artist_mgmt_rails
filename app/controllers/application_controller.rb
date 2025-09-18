class ApplicationController < ActionController::API
  include ActionController::Cookies

  before_action :authorize_request
  attr_accessor :current_user
  
  def authorize_request
    access_token = cookies.signed[:access_token]
    decoded = JsonWebToken.decode(access_token)
    @current_user = User.find_by(id: decoded["id"]) if decoded 
    #  puts "Current user: #{current_user.id} #{current_user.email} #{current_user.role}" if current_user 
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end
end
