class SunTimesRetriever
  class APIError < StandardError; end

  def initialize(lat:, lng:, date_start:, date_end:)
    @lat = lat
    @lng = lng
    @date_start = date_start
    @date_end = date_end
  end

  def fetch
    if ! data_exists_in_db?
      api_data = fetch_from_api
      parsed_data = extract_data(api_data)
      store_in_db(parsed_data)
    end

    data_from_db
  end

  private

    def data_exists_in_db?
      # +1 because includes both dates
      expected_days = (Date.parse(@date_end) - Date.parse(@date_start)).to_i + 1
      actual_days = SunEventDay.where(
        latitude: @lat,
        longitude: @lng,
        date: @date_start..@date_end
      ).distinct.count(:date)

      actual_days == expected_days
    end

  def data_from_db
    SunEventDay
      .includes(:sun_event_times)
      .where(
        latitude: @lat,
        longitude: @lng,
        date: @date_start..@date_end
      )
      .map do |day|
        times = day.sun_event_times.index_by(&:event_type)

        {
          date:        day.date,
          sunrise:     times['sunrise']&.event_time&.strftime('%I:%M:%S %p'),
          sunset:      times['sunset']&.event_time&.strftime('%I:%M:%S %p'),
          golden_hour: times['golden_hour']&.event_time&.strftime('%I:%M:%S %p')
        }
      end
  end

  def fetch_from_api
    conn = Faraday.new(
      url: 'https://api.sunrisesunset.io',
      headers: { 'Content-Type' => 'application/json' }
    )

    response = conn.get('/json') do |req|
      req.params['lat'] = @lat
      req.params['lng'] = @lng
      req.params['date_start'] = @date_start
      req.params['date_end'] = @date_end
    end

    unless response.success?
      raise APIError, "HTTP error: #{response.status} - #{response.body}"
    end

    data = JSON.parse(response.body)

    unless data['status'] == 'OK'
      raise APIError, "API status not OK: #{data["status"]} - #{response.body}"
    end

    data

  rescue Faraday::Error, JSON::ParserError, StandardError => e
    raise APIError, "Connection or parse error: #{e.class} - #{e.message}"
  end

  def extract_data(api_data)
    api_data['results'].map { |data|
      {
        date:        data['date'],
        sunrise:     data['sunrise'],
        sunset:      data['sunset'],
        golden_hour: data['golden_hour']
      }
    }
  end

  def store_in_db(results)
    results.each do |data|
      day = SunEventDay.find_or_create_by!(
        date:      data[:date],
        latitude:  @lat,
        longitude: @lng
      )

      {
        sunrise:     data[:sunrise],
        sunset:      data[:sunset],
        golden_hour: data[:golden_hour]
      }.each do |event_type, event_time|
        next unless event_time

        day.sun_event_times.find_or_create_by!(
          event_type: event_type.to_s
      ) do |event|
          event.event_time = event_time
        end
      end
    end
  end
end
