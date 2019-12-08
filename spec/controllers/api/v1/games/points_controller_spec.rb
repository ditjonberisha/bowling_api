require 'rails_helper'

RSpec.describe Api::V1::Games::PointsController, type: :controller do
  describe 'create' do
    let(:game) { create(:game) }
    it 'should return parameter missing for nil points' do
      params = { game_id: game.id, points: nil }
      exp_response = { status: 400, error: 'parameter_missing', message: 'points parameter is required' }

      post 'create', params: params

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eq(exp_response.with_indifferent_access)
    end

    it 'should create strike (first ball 10 points)' do
      frame = create(:frame, number: 1, first_ball: nil)
      game.update(active_frame: frame)
      params = { game_id: game.id, points: 10 }
      exp_response = { status: 200, result: { id: game.id, points: 10, shot: 'first_ball', type: 'strike' } }

      post 'create', params: params

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(exp_response.with_indifferent_access)
    end

    it 'should create spare (first and second ball 10 points)' do
      frame = create(:frame, number: 1, first_ball: 4)
      game.update(active_frame: frame)
      params = { game_id: game.id, points: 6 }
      exp_response = { status: 200, result: { id: game.id, points: 6, shot: 'second_ball', type: 'spare' } }

      post 'create', params: params

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(exp_response.with_indifferent_access)
    end

    it 'should create 5 points' do
      frame = create(:frame, number: 1, first_ball: nil)
      game.update(active_frame: frame)
      params = { game_id: game.id, points: 5 }
      exp_response = { status: 200, result: { id: game.id, points: 5, shot: 'first_ball', type: 'normal' } }

      post 'create', params: params

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(exp_response.with_indifferent_access)
    end

    it 'should return game closed' do
      frame = create(:frame, number: 1)
      game.update(status: :completed, active_frame: frame)
      params = { game_id: game.id, points: 5 }
      exp_response = { status: 400, error: 'game_closed', message: 'Game Completed!' }

      post 'create', params: params

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eq(exp_response.with_indifferent_access)
    end

    it 'should return error for invalid points' do
      frame = create(:frame, number: 1)
      game.update(active_frame: frame)
      params = { game_id: game.id, points: 11 }
      exp_response = { status: 400, error: 'invalid_input', message: ['Points 11 out of points range.'] }

      post 'create', params: params

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eq(exp_response.with_indifferent_access)
    end
  end
end
