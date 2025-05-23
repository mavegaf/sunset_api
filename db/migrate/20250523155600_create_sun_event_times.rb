class CreateSunEventTimes < ActiveRecord::Migration[8.0]
  def change
    create_table :sun_event_times do |t|
      t.references :sun_event_day, null: false, foreign_key: true
      t.string :event_type
      t.time :event_time

      t.timestamps
    end
  end
end
