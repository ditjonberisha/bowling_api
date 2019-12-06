module GameCore
  class GameService
    include ActiveModel::Validations
    include Constants

    attr_reader :game

    validates :game, presence: true

    def initialize(game)
      @game = game
    end

    def add_points(points)
      raise errors.full_messages unless valid?
      raise Errors::Game::GameClosed if game.completed?

      create_next_frame if next_frame?
      point = GameCore::Frame::Point.new(game, points)
      point.create
    end

    private
      def next_frame?
        return false if game.active_frame.number + 1 > MAX_FRAMES
        return true if game.active_frame.strike?
        !game.active_frame.second_ball.nil?
      end

      def create_next_frame
        new_frame = game.frames.create!(number: game.active_frame.number + 1)
        game.update!(active_frame: new_frame)
      end
  end
end
