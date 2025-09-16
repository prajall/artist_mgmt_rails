require "jwt"

class JsonWebToken
  SECRET_KEY = "jwtsecret"
  ACCESS_TOKEN_EXPIRY = 15.minutes.freeze
  REFRESH_TOKEN_EXPIRY = 7.days.freeze

  def self.encode(payload, exp = 24.hours.from_now)
    puts "Payload: #{payload}"
    encoded = JWT.encode(payload, SECRET_KEY)
    puts "Encoded: #{encoded}"
    encoded
  end

  def self.decode(token) 
    decoded = JWT.decode(token, SECRET_KEY)[0]
    puts "Decoded: #{decoded}"
    decoded
    # HashWithIndifferentAccess.new(decoded)

  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  def self.generate_access_token(payload)
    self.encode(payload, ACCESS_TOKEN_EXPIRY.from_now)
  end

  def self.generate_refresh_token(payload)
    self.encode(payload, REFRESH_TOKEN_EXPIRY.from_now)
  end
end
