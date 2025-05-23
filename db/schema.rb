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

ActiveRecord::Schema[8.0].define(version: 2025_05_23_155600) do
  create_table "sun_event_days", force: :cascade do |t|
    t.date "date"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "latitude", "longitude"], name: "index_sun_event_days_on_date_and_latitude_and_longitude", unique: true
  end

  create_table "sun_event_times", force: :cascade do |t|
    t.integer "sun_event_day_id", null: false
    t.string "event_type"
    t.time "event_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sun_event_day_id"], name: "index_sun_event_times_on_sun_event_day_id"
  end

  add_foreign_key "sun_event_times", "sun_event_days"
end
