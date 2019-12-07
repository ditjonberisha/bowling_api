module GameCore
  class GameService
    include ActiveModel::Validations
    include Constants

    attr_reader :game

    validates :game, :current_frame, presence: true

    def initialize(game)
      @game = game
    end

    def add_points(points)
      raise Errors::Game::InvalidInput.new(errors.full_messages) unless valid?
      raise Errors::Game::GameClosed if game.completed?

      create_next_frame if next_frame?

      point = GameCore::Frame::Point.new(game, points)
      point.create
    end

    def current_frame
      @current_frame ||= game&.active_frame
    end

    private
      def next_frame?
        return false if current_frame.number + 1 > MAX_FRAMES
        return true if current_frame.strike?
        !current_frame.second_ball.nil?
      end

      def create_next_frame
        new_frame = game.frames.create!(number: current_frame.number + 1)
        game.update!(active_frame: new_frame)
      end
  end
end
