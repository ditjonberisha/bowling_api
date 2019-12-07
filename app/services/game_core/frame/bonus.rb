module GameCore::Frame
  class Bonus
    attr_reader :game, :points

    def initialize(game, points)
      @game = game
      @points = points
    end

    def update
      bonus = add_bonus(previous_frame)
      bonus += add_bonus(previous_previous_frame)
      bonus
    end

    def previous_frame
      game&.frame_by_number(game&.active_frame&.number - 1)
    end

    def previous_previous_frame
      game&.frame_by_number(game&.active_frame&.number - 2)
    end

    private
      def add_bonus(frame)
        return 0 if frame.nil?
        return 0 unless has_bonus?(frame)
        frame.strike? && frame.second_ball.nil? ? frame.update!(second_ball: points) : frame.update!(third_ball: points)
        points
      end

      def has_bonus?(frame)
        frame.status != 'normal' && frame.third_ball.nil?
      end
  end
end
