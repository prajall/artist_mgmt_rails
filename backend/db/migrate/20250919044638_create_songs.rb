class CreateSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :songs do |t|
      t.string :title, null: false
      t.string :genre, null: true, default: "Music"   
      t.references :artist, null: false, foreign_key: {to_table: :artists}
      t.timestamps
    end
  end
end
