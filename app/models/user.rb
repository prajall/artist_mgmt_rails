class User < ApplicationRecord
  has_secure_password

  validates :first_name, :last_name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: %w[user artist artist_manager super_admin] } 
  validates :phone, length: { maximum: 15 }, allow_blank: true
  validates :gender, presence: true, inclusion: { in: %w[male female other] } 
  validates :address, length: { maximum: 500 }, allow_blank: true

  normalizes :email, with: ->(e) { e.strip.downcase }
end
