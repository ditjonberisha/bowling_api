module Errors::Game
  class GameClosed < ::Errors::GameError
    def initialize
      super(:game_closed, 400, 'Game Completed!')
    end
  end
end
