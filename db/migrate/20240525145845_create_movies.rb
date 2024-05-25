class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.string :description
      t.string :director
      t.string :year
      t.string :filming_location
      t.string :country
      t.string :actors, array: true, default: []

      t.timestamps
    end

    add_index :movies, :title, unique: true
    add_index :movies, :actors, using: :gin
  end
end
