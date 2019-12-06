module GameCore::Frame
  class Point
    include GameCore::Constants

    attr_reader :game, :current_frame, :points, :shot

    def initialize(game, points)
      @game = game
      @points = points.to_i
      @shot = current_frame.next_shot
    end

    def create
      raise errors.full_messages unless valid?
      # TODO create points
    end

    def current_frame
      @current_frame ||= game.active_frame
    end
  end
end
