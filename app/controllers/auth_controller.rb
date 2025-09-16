class AuthController < ApplicationController
  def login
    email = params[:email]  
    password = params[:password]

    user = User.find_by(email: email)
    
    if user&.authenticate(password)
      access_token = JsonWebToken.generate_access_token(user)
      refresh_token = JsonWebToken.generate_refresh_token(user)

      cookies.signed[:access_token] = {
        value: access_token,
        httponly: true,
        secure: true,
        same_site: nil,
        expires: 15.minutes.from_now
      }

      cookies.signed[:refresh_token] = {
        value: refresh_token,
        httponly: true,
        secure: true,
        same_site: nil,
        expires: 7.days.from_now
      }

      render json: {message: "Login Successful"}
      
    else
      render json: {error: "User not found."}, status: 404
    end
  end
end