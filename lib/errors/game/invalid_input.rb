module Errors::Game
  class InvalidInput < ::Errors::GameError
    def initialize(message)
      super(:invalid_input, 400, message)
    end
  end
end
