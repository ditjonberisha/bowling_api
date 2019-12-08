require 'rails_helper'

include GameCore

RSpec.describe GameCore::GameService do
  describe 'validation' do
    it 'should validate presence of game and current_frame' do
      game_service = GameService.new(nil)
      expect(game_service).to_not be_valid
      expect(game_service.errors[:game]).to include("can't be blank")
      expect(game_service.errors[:current_frame]).to include("can't be blank")
    end
  end

  describe '#add_points' do
    it 'should call create point' do
      game = create(:game_with_callbacks)
      game_service = GameService.new(game)

      expect_any_instance_of(GameCore::Frame::Point).to receive(:create)
      game_service.add_points(10)
    end

    context 'should create new frame' do
      it 'if active frame status is strike' do
        game = create(:game, active_frame: create(:frame, number: 1, first_ball: 10, status: :strike))
        game_service = GameService.new(game)

        expect { game_service.add_points(10) }.to change(game.frames, :count).by(1)
        expect(game.active_frame.number).to eq(2)
      end

      it 'if active frame second ball is not nil' do
        game = create(:game, active_frame: create(:frame, number: 1, first_ball: 1, second_ball: 1))
        game_service = GameService.new(game)

        expect { game_service.add_points(10) }.to change(game.frames, :count).by(1)
        expect(game.active_frame.number).to eq(2)
      end
    end

    it 'should not create new frame if we are in last frame' do
      game = create(:game, active_frame: create(:frame, number: 10, first_ball: 10, status: :strike))
      game_service = GameService.new(game)

      expect { game_service.add_points(10) }.to change(game.frames, :count).by(0)
      expect(game.active_frame.number).to eq(10)
    end

    it 'should return game closed' do
      game = create(:game_with_callbacks, status: :completed)
      game_service = GameService.new(game)

      expect { game_service.add_points(10) }.to raise_error(Errors::Game::GameClosed)
    end
  end

  describe 'create points different scenarios' do
    it 'should have total score 300 if we score 12 strike' do
      points = Array.new(12, 10)
      scores = Array.new(10, 30)
      test_scores(points, scores, true)
    end

    it 'should have total score 150 if we score 10 spare and last shot 5' do
      points = Array.new(21, 5)
      scores = Array.new(10, 15)
      test_scores(points, scores, true)
    end

    it 'all shots 0' do
      points = Array.new(20, 0)
      scores = Array.new(10, 0)
      test_scores(points, scores, true)
    end

    it 'all shots 1' do
      points = Array.new(20, 1)
      scores = Array.new(10, 2)
      test_scores(points, scores, true)
    end

    it 'should test different points and scores' do
      points = [1, 2, 3, 4, 5, 2, 10]
      scores = [3, 7, 7, 10]
      test_scores(points, scores)

      points = [10, 6, 4, 10, 10, 5, 0, 2]
      scores = [20, 20, 25, 15, 5, 2]
      test_scores(points, scores)

      points = [6, 4, 5, 0, 10, 2, 3, 5, 5, 10, 0, 9, 10, 7, 3, 10, 10, 10]
      scores = [15, 5, 15, 5, 20, 19, 9, 20, 20, 30]
      test_scores(points, scores, true)
    end
  end

  def test_scores(points, scores, game_closed = false)
    game = create(:game_with_callbacks)
    game_service = GameService.new(game)

    points.each do |p|
      game_service.add_points(p)
    end

    game.frames.each_with_index do |frame, index|
      expect(frame.score).to eq(scores[index])
    end

    expect(game.total_score).to eq(scores.inject(:+))
    expect { game_service.add_points(10) }.to raise_error(Errors::Game::GameClosed) if game_closed
  end
end