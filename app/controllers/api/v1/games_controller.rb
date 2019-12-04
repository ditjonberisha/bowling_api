class Api::V1::GamesController < Api::V1::BaseController
  before_action :set_game, only: :show

  def create
    game = Game.new(game_params)

    game.save!
    object_json(game, GameSerializer)
  end

  def show
    object_json(@game, GameSerializer)
  end

  protected
    def set_game
      @game = Game.find params[:id]
    end

    def game_params
      { name: params.require(:name) }
    end

    def object_json(object, serializer, _status = nil)
      render json: object, serializer: serializer, status: _status || 200
    end
end
