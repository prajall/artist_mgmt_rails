class Song < ApplicationRecord
  has_one_attached :song_cover

  belongs_to :artist, class_name: "Artist", foreign_key: "artist_id", dependent: :destroy

  validates :title, length: {minimum: 3, maximum: 100}
  validates :artist, presence:true
end
