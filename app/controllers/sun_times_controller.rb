class SunTimesController < ApplicationController
  def index
    lat        = params.require(:lat)
    lng        = params.require(:lng)
    date_start = params.require(:date_start) # TODO check if date is valid
    date_end   = params.require(:date_end)

    data = SunTimesRetriever.new(
      lat: lat,
      lng: lng,
      date_start: date_start,
      date_end: date_end,
    ).fetch

    render json: data, status: :ok

  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request

  rescue SunTimesRetriever::APIError => e
    render json: { error: e.message }, status: :bad_gateway
  end
end
