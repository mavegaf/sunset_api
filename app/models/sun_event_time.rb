class SunEventTime < ApplicationRecord
  belongs_to :sun_event_day

  VALID_EVENT_TYPES = %w[sunrise sunset golden_hour]

  validates :event_type, presence: true, inclusion: { in: VALID_EVENT_TYPES }
end
