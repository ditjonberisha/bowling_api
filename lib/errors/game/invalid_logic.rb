module Errors::Game
  class InvalidLogic < ::Errors::GameError
    include GameCore::Constants

    def initialize
      super(:invalid_logic, 400, "Both rolls can not add more than #{MAX_PINS}!")
    end
  end
end
