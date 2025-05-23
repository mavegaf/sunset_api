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
      actual_days = SunEvent.where(
        latitude: @lat,
        longitude: @lng,
        date: @date_start..@date_end
      ).distinct.count(:date)

      actual_days == expected_days
    end

  def data_from_db
    SunEvent
      .where(
        latitude: @lat,
        longitude: @lng,
        date: @date_start..@date_end
      )
      .select(:date, :sunrise, :sunset, :golden_hour)
      .map { |event|
        {
          date: event.date,
          sunrise: event.sunrise.strftime('%I:%M:%S %p'),
          sunset: event.sunset.strftime('%I:%M:%S %p'),
          golden_hour: event.golden_hour.strftime('%I:%M:%S %p')
        }
      }
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
    # some of the data could already be in the DB, only add the new ones
    # The table will not be normalized: sunrise, sunset and golden_hour could be null
    # since I'm interested in storing all the dates that I have queried even if there is
    # no data
    results.each do |data|
      SunEvent.find_or_create_by!(
        date:         data[:date],
        latitude:     @lat,
        longitude:    @lng,
      ) do |event|
        event.sunrise     = data[:sunrise]
        event.sunset      = data[:sunset]
        event.golden_hour = data[:golden_hour]
      end
    end
  end
end
