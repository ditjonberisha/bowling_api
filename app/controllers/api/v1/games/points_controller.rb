class Api::V1::Games::PointsController < Api::V1::Games::BaseController
  def create
    game_service = GameCore::GameService.new(@game)
    game_service.add_points(points_params)
    render json: :ok
  end

  protected
    def points_params
      params.require(:points)
    end
end
