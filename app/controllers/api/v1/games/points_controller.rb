class Api::V1::Games::PointsController < Api::V1::Games::BaseController
  def create
    game_service = GameCore::GameService.new(@game)
    result = game_service.add_points(points_params)
    json_response(result)
  end

  protected
    def points_params
      params.require(:points)
    end
end
