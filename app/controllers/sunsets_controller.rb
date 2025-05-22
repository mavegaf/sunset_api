class SunsetsController < ApplicationController
  def index
    render json: { error: "Error al obtener datos" }, status: :bad_gateway
  end
end
