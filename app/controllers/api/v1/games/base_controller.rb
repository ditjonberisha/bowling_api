class Api::V1::Games::BaseController < Api::V1::BaseController
  before_action :set_game

  protected
    def set_game
      @game = Game.find params[:game_id] || params[:id]
    end
end
