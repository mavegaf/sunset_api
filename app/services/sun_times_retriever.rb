class SunTimesRetriever
  class APIError < StandardError; end

  def initialize(lat:, lng:, date_start:, date_end:)
    @lat = lat
    @lng = lng
    @date_start = date_start
    @date_end = date_end
  end

  def fetch
    if data_exists_in_db?
      data_from_d
    else
      api_data = fetch_from_api
      parsed_data = extract_data(api_data)
      # store_in_db(parsed_data)
      # parsed_data
    end
  end

  private

    def data_exists_in_db?
      false
    end

  def data_from_db
    false
  end

  def fetch_from_api
    conn = Faraday.new(
      url: "https://api.sunrisesunset.io",
      params: { param: "1" },
      headers: { "Content-Type" => "application/json" }
    )

    response = conn.get("/json") do |req|
      req.params["lat"] = @lat
      req.params["lng"] = @lng
      req.params["date_start"] = @date_start
      req.params["date_end"] = @date_end
    end

    unless response.success?
      raise APIError, "HTTP error: #{response.status} - #{response.body}"
    end

    data = JSON.parse(response.body)

    unless data["status"] == "OK"
      raise APIError, "API status not OK: #{data["status"]} - #{response.body}"
    end

    data

  rescue Faraday::Error, JSON::ParserError, StandardError => e
    raise APIError, "Connection or parse error: #{e.class} - #{e.message}"
  end

  def extract_data(api_data)
    api_data["results"].map { |data|
      {
        sunrise:     data["sunrise"],
        sunset:      data["sunset"],
        golden_hour: data["golden_hour"]
      }
    }
  end

  def store_in_db(data)
    # Guardar los datos en la tabla correspondiente
  end
end
