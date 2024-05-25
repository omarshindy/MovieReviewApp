# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_25_145846) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "movies", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.string "director"
    t.string "year"
    t.string "filming_location"
    t.string "country"
    t.string "actors", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actors"], name: "index_movies_on_actors", using: :gin
    t.index ["title"], name: "index_movies_on_title", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.string "reviewer"
    t.integer "stars"
    t.text "review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
  end

  add_foreign_key "reviews", "movies"
end
