class User < ApplicationRecord
  has_secure_password

  has_one :artist, class_name: "Artist", foreign_key: "user_id", dependent: :destroy
  has_one :managed_artist, class_name: "Artist", foreign_key: "manager_id", dependent: :destroy 

  validates :first_name, :last_name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  enum role: {artist: "artist", artist_manager: "artist_manager", super_admin: "super_admin"}
  validates :role, presence: true
  validates :phone, length: { maximum: 15 }, allow_blank: true
  validates :gender, presence: true, inclusion: { in: %w[male female other] } 
  validates :address, length: { maximum: 500 }, allow_blank: true

  normalizes :email, with: ->(e) { e.strip.downcase }
end
