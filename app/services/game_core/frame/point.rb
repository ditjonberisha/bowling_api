module GameCore::Frame
  class Point
    include ActiveModel::Validations
    include GameCore::Constants

    attr_reader :game, :current_frame, :points, :shot

    validates :points, inclusion: { in: ALLOWED_POINTS, message: '%{value} out of points range.' }
    validates :game, :current_frame, :shot, presence: true

    def initialize(game, points)
      @game = game
      @points = points.to_i
      @shot = current_frame&.next_shot
    end

    def create
      raise Errors::Game::InvalidInput.new(errors.full_messages) unless valid?

      ActiveRecord::Base.transaction do
        update_frame
        update_game
      end

      respond
    end

    def current_frame
      @current_frame ||= game&.active_frame
    end

    private
      def set_shot
        current_frame.send("#{shot}=", points)
      end

      def strike?
        current_frame.first_ball.to_i == MAX_PINS
      end

      def spare?
        current_frame.first_ball.to_i + current_frame.second_ball.to_i == MAX_PINS
      end

      def update_frame
        set_shot
        raise Errors::Game::InvalidLogic if check_max_pins

        if strike?
          current_frame.status = :strike
        elsif spare?
          current_frame.status = :spare
        else
          current_frame.status = :normal
        end
        current_frame.save!
      end

      def update_bonus
        Bonus.new(game, points).update
      end

      def update_game
        bonus = update_bonus
        game.status = check_game_status
        game.total_score += points + bonus
        game.save!
      end

      def check_game_status
        if game.active_frame.number == MAX_FRAMES
          return :completed if shot == :second_ball && game.active_frame.status == 'normal'
          return :completed if shot == :third_ball
        end
        :active
      end

      def check_max_pins
        !strike? && current_frame.first_ball.to_i + current_frame.second_ball.to_i > MAX_PINS
      end

      def respond
        { id: game.id, points: points, shot: shot, type: current_frame.status }
      end
  end
end
