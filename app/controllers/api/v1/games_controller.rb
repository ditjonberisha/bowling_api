class Api::V1::GamesController < Api::V1::BaseController
  before_action :set_game, only: :show

  def create
    game = Game.new(game_params)

    game.save!
    serialize_object(game, CreateGameSerializer)
  end

  def show
    serialize_object(@game, GameSerializer)
  end

  protected
    def set_game
      @game = Game.find params[:id]
    end

    def game_params
      { name: params.require(:name) }
    end
end
