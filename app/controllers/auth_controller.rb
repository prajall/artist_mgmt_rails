class AuthController < ApplicationController
  skip_before_action :authorize_request

  def login
    email = params[:email]  
    password = params[:password]

    user = User.find_by(email: email)

    if !user
     return render json: {error: "User not found."}, status: 404
    end
    
    if user&.authenticate(password)
      payload = {
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        role: user.role
      }
      access_token = JsonWebToken.generate_access_token(payload)
      refresh_token = JsonWebToken.generate_refresh_token(payload)
      
      puts "Generated Access Token: #{access_token}"

      cookies.signed[:access_token] = {
        value: access_token,
        httponly: true,
        secure: true,
        same_site: nil
      }

      cookies.signed[:refresh_token] = {
        value: refresh_token,
        httponly: true,
        secure: true,
        same_site: nil
      }

      render json: {message: "login successful"}
      
    else
      render json: {error: "Invalid Credential"}, status: 400
    end
  end
end
