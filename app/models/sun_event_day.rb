class SunEventDay < ApplicationRecord
  has_many :sun_event_times, dependent: :destroy
end
