class CreateSunEventDays < ActiveRecord::Migration[8.0]
  def change
    create_table :sun_event_days do |t|
      t.date :date
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end

    add_index :sun_event_days, [ :date, :latitude, :longitude ], unique: true
  end
end
