class SunTimesController < ApplicationController
  include DateValidation

  def index
    lat        = params.require(:lat)
    lng        = params.require(:lng)
    date_start = params.require(:date_start)
    date_end   = params.require(:date_end)

    unless valid_date?(date_start) && valid_date?(date_end)
      return render json: { error: 'Invalid date format (use YYYY-MM-DD)' }, status: :bad_request
    end

    unless date_range_within_one_year?(date_start, date_end)
      return render json: { error: 'Date range cannot exceed 1 year' }, status: :bad_request
    end

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
