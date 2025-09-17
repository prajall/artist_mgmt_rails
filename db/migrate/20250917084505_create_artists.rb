class CreateArtists < ActiveRecord::Migration[8.0]
  def change
    create_table :artists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :manager, null: false, foreign_key: {to_table: :users}
      t.string :artist_name, null: false
      t.integer :first_release_year
      t.integer :no_of_albums_released
      t.timestamps
    end
  end
end
