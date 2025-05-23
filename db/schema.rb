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

ActiveRecord::Schema[8.0].define(version: 2025_05_22_192322) do
  create_table "sun_events", force: :cascade do |t|
    t.date "date", null: false
    t.decimal "latitude", precision: 8, scale: 5, null: false
    t.decimal "longitude", precision: 8, scale: 5, null: false
    t.time "sunrise"
    t.time "sunset"
    t.time "golden_hour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "latitude", "longitude"], name: "index_sun_events_on_date_and_latitude_and_longitude", unique: true
  end
end
