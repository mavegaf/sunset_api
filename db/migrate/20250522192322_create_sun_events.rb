class CreateSunEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :sun_events do |t|
      t.date :date, null: false
      t.decimal :latitude, precision: 8, scale: 5, null: false
      t.decimal :longitude, precision: 8, scale: 5, null: false
      t.time :sunrise
      t.time :sunset
      t.time :golden_hour

      t.timestamps
    end

    add_index :sun_events, [ :date, :latitude, :longitude ], unique: true
  end
end
