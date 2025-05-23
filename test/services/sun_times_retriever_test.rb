require 'test_helper'

class SunTimesRetrieverTest < ActiveSupport::TestCase
  fixtures :sun_event_days, :sun_event_times

  def setup
    @lat = '40.7128'
    @lng = '-74.0060'
    @date_start = '2024-01-01'
    @date_end = '2024-01-03'
    @service = SunTimesRetriever.new(lat: @lat, lng: @lng, date_start: @date_start, date_end: @date_end)
  end

  test 'returns data from DB when it already exists' do
    @service.define_singleton_method(:fetch_from_api) do
      flunk('API should not be called when data exists in DB')
    end

    result = @service.fetch
    assert_equal 3, result.size
    assert result.all? { |r| r[:sunrise].present? && r[:sunset].present? && r[:golden_hour].present? }
  end

  test 'extract_data parses API results correctly' do
    input = {
      'results' => [
        { 'date' => '2024-01-01', 'sunrise' => '06:00', 'sunset' => '18:00', 'golden_hour' => '17:30', 'first_light': '5:52:30 AM', 'last_light': '6:33:25 PM' }
      ]
    }

    expected = [
      {
        date: '2024-01-01',
        sunrise: '06:00',
        sunset: '18:00',
        golden_hour: '17:30'
      }
    ]

    assert_equal expected, @service.send(:extract_data, input)
  end

  test 'calls fetch_from_api when DB has no data for given dates' do
    called = false

    service = SunTimesRetriever.new(
      lat: @lat,
      lng: @lng,
      date_start: '2025-02-01', # Dates not in the fixtures
      date_end:   '202%-02-01'
    )

    service.define_singleton_method(:fetch_from_api) do
      called = true
      { 'status' => 'OK', 'results' => [] }
    end

    service.fetch
    assert called, 'Expected fetch_from_api to be called for missing DB dates'
  end
end
