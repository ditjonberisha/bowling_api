class Api::V1::BaseController < ApplicationController
  include Errors::ErrorHandler
  include Helpers::Render

  def api
    render json: api_json, status: 200
  end

  private
    def api_json
      {
          status: :ok,
          new_game_url: api_v1_games_url,
          new_points_url: api_v1_game_points_url(':game_id', ':points'),
          game_score_url: api_v1_game_url(':id')
      }
    end
end
