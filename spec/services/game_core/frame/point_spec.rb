require 'rails_helper'

include GameCore::Frame

RSpec.describe GameCore::Frame::Point do
  describe 'validation' do
    it 'should validate presence of game, current_frame and shot' do
      point = Point.new(nil, 10)
      expect(point).to_not be_valid
      expect(point.errors[:game]).to include("can't be blank")
      expect(point.errors[:current_frame]).to include("can't be blank")
      expect(point.errors[:shot]).to include("can't be blank")
    end

    it 'should validate inclusion of points' do
      point = Point.new(create(:game_with_callbacks), 11)
      expect(point).to_not be_valid
      expect(point.errors[:points]).to include('11 out of points range.')
    end
  end

  describe '#create' do
    let(:game) { create(:game) }

    it 'should add 10 points in first ball and make strike' do
      active_frame = create(:frame, number: 1)
      game.update(active_frame: active_frame)
      points = 10
      exp_response = { id: game.id, points: points, shot: :first_ball, type: 'strike' }
      point = Point.new(game, points)

      expect(point.create).to eq(exp_response)
      expect(active_frame.first_ball).to eq(points)
    end

    it 'should add 9 points in second ball and make spare' do
      active_frame = create(:frame, first_ball: 1, number: 1)
      game.update(active_frame: active_frame)
      points = 9
      exp_response = { id: game.id, points: points, shot: :second_ball, type: 'spare' }
      point = Point.new(game, points)

      expect(point.create).to eq(exp_response)
      expect(active_frame.second_ball).to eq(points)
    end

    it 'should add different points in first ball' do
      active_frame = create(:frame, number: 1)
      game.update(active_frame: active_frame)
      0..10.times do |i|
        points = i
        exp_response = { id: game.id, points: points, shot: :first_ball, type: 'normal' }
        point = Point.new(game, points)

        expect(point.create).to eq(exp_response)
        expect(active_frame.first_ball).to eq(points)
        active_frame.update(first_ball: nil)
      end
    end

    it 'should add different points in second ball' do
      active_frame = create(:frame, first_ball: 0, number: 1)
      game.update(active_frame: active_frame)
      0..10.times do |i|
        points = i
        exp_response = { id: game.id, points: points, shot: :second_ball, type: 'normal' }
        point = Point.new(game, points)

        expect(point.create).to eq(exp_response)
        expect(active_frame.second_ball).to eq(points)
        active_frame.update(second_ball: nil)
      end
    end

    it 'should change status of the game for normal frame' do
      active_frame = create(:frame, first_ball: 0, number: 10)
      points = 1
      game.update(active_frame: active_frame)
      exp_response = { id: game.id, points: points, shot: :second_ball, type: 'normal' }

      point = Point.new(game, points)
      expect(point.create).to eq(exp_response)
      expect(active_frame.second_ball).to eq(points)
      expect(game.status).to eq('completed')
    end

    it 'should change status of the game after third ball for strike frame' do
      active_frame = create(:frame, first_ball: 10, second_ball: 10, number: 10, status: :strike)
      game.update(active_frame: active_frame)
      exp_response = { id: game.id, points: 10, shot: :third_ball, type: 'strike' }

      point = Point.new(game, 10)
      expect(point.create).to eq(exp_response)
      expect(active_frame.third_ball).to eq(10)
      expect(game.status).to eq('completed')
    end

    it 'should throw error both balls can not add more than 10' do
      active_frame = create(:frame, first_ball: 9, number: 1)
      game.update(active_frame: active_frame)
      point = Point.new(game, 9)

      expect { point.create }.to raise_error(Errors::Game::InvalidLogic)
    end

    it 'should throw error for not valid points' do
      active_frame = create(:frame, number: 1)
      game.update(active_frame: active_frame)
      point = Point.new(game, 11)

      expect { point.create }.to raise_error(Errors::Game::InvalidInput)
    end
  end
end
