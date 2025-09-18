class Artist < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :manager, class_name: "User"

  attr_readonly :no_of_albums_released

  validates :artist_name, presence: true, length: {minimum: 3, maximum: 100}
  validates :first_release_year, numericality: {greater_than: 1800, less_than: Date.current.year} 
end
