require 'rails_helper'

RSpec.describe Api::V1::GamesController, type: :controller do
  describe 'create' do
    it 'should create new game' do
      params = { name: 'user' }
      expect { post 'create', params: params }.to change(Game, :count).by(1)
      exp_response = { id: Game.last.id, name: params[:name], status: 'active' }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(exp_response.with_indifferent_access)
    end

    it 'should return parameter missing for nil name' do
      params = { name: nil }
      exp_response = { status: 400, error: 'parameter_missing', message: 'name parameter is required' }

      post 'create', params: params

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eq(exp_response.with_indifferent_access)
    end
  end

  describe 'show' do
    it 'should return game with frames' do
      game = create(:game, total_score: 40)
      frame1 = create(:frame, game: game, number: 1, first_ball: 10, second_ball: 6, third_ball: 4, status: :strike)
      frame2 = create(:frame, game: game, number: 2, first_ball: 6, second_ball: 4, third_ball: 5, status: :spare)
      frame3 = create(:frame, game: game, number: 2, first_ball: 5, status: :normal)

      exp_response = {
          id: game.id,
          name: game.name,
          total_score: 40,
          status: 'active',
          frames: [
              {
                  number: frame1.number,
                  first_ball: frame1.first_ball,
                  second_ball: frame1.second_ball,
                  third_ball: frame1.third_ball,
                  status: frame1.status,
                  score: frame1.score
              },
              {
                  number: frame2.number,
                  first_ball: frame2.first_ball,
                  second_ball: frame2.second_ball,
                  third_ball: frame2.third_ball,
                  status: frame2.status,
                  score: frame2.score
              },
              {
                  number: frame3.number,
                  first_ball: frame3.first_ball,
                  second_ball: frame3.second_ball,
                  third_ball: frame3.third_ball,
                  status: frame3.status,
                  score: frame3.score
              }
          ]
      }

      get 'show', params: { id: game.id }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(exp_response.with_indifferent_access)
    end

    it 'should return not found' do
      exp_response = { error: 'record_not_found', message: "Couldn't find Game with 'id'=123", status: 404 }
      post 'show', params: { id: 123 }

      expect(response.status).to eq(404)
      expect(JSON.parse(response.body)).to eq(exp_response.with_indifferent_access)
    end
  end
end
