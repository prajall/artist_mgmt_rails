class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false, limit: 100
      t.string :last_name, null: false, limit: 100
      t.string :email, null: false, limit: 255
      t.string :role, null: false, limit: 50, default: "user"
      t.string :phone
      t.string :gender, limit: 10, null: false, default: "other"
      t.string :address
      t.date :dob
      t.string :profile_image

      t.timestamps default: -> { "CURRENT_TIMESTAMP" }
    end
    add_index :users, :email, unique: true
  end
end
