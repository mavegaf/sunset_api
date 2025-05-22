class SunsetsController < ApplicationController
  def index
    # lat=38.907192&lng=-77.036873
    lat = params.require(:lat)
    lng = params.require(:lng)
    date_start = params.require(:date_start)
    date_end = params.require(:date_end)

    conn = Faraday.new(
      url: "https://api.sunrisesunset.io",
      params: { param: "1" },
      headers: { "Content-Type" => "application/json" }
    )

    response = conn.get("/json") do |req|
      req.params["lat"] = lat
      req.params["lng"] = lng
      req.params["date_start"] = date_start
      req.params["date_end"] = date_end
    end

    if response.success?
      render json: JSON.parse(response.body), status: :ok
    else
      render json: { error: "Failing to get data" }, status: :bad_gateway
    end

  rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
  end
end
