require 'rails_helper'

include GameCore::Frame

RSpec.describe GameCore::Frame::Bonus do
  describe '#update' do
    let(:game) { create(:game, active_frame: create(:frame, number: 3)) }

    it 'should update second ball previous strike and third ball for previous previous strike' do
      frame1 = create(:frame, game: game, number: 2, first_ball: 10, second_ball: nil, status: :strike)
      frame2 = create(:frame, game: game, number: 1, first_ball: 10, second_ball: 10, third_ball: nil, status: :strike)
      bonus = Bonus.new(game, 10)

      expect(bonus.update).to eq(20)

      frame1.reload
      frame2.reload
      expect(frame1.second_ball).to eq(10)
      expect(frame2.third_ball).to eq(10)
    end

    it 'should update second ball for strike and third ball for spare' do
      frame1 = create(:frame, game: game, number: 2, first_ball: 10, second_ball: nil, status: :strike)
      frame2 = create(:frame, game: game, number: 1, first_ball: 5, second_ball: 5, status: :spare)
      bonus = Bonus.new(game, 10)

      expect(bonus.update).to eq(20)

      frame1.reload
      frame2.reload
      expect(frame1.second_ball).to eq(10)
      expect(frame2.third_ball).to eq(10)
    end

    it 'should update third ball for strike and none for normal' do
      frame1 = create(:frame, game: game, number: 2, first_ball: 10, second_ball: 10,  status: :strike)
      frame2 = create(:frame, game: game, number: 1, first_ball: 5, second_ball: 5, status: :normal)
      bonus = Bonus.new(game, 5)

      expect(bonus.update).to eq(5)

      frame1.reload
      frame2.reload
      expect(frame1.third_ball).to eq(5)
      expect(frame2.third_ball).to eq(nil)
    end

    it 'should not update third ball for normal status' do
      frame1 = create(:frame, game: game, number: 2, first_ball: 2, second_ball: 2,  status: :normal)
      frame2 = create(:frame, game: game, number: 1, first_ball: 2, second_ball: 2, status: :normal)
      bonus = Bonus.new(game, 5)

      expect(bonus.update).to eq(0)

      frame1.reload
      frame2.reload
      expect(frame1.third_ball).to_not be
      expect(frame2.third_ball).to_not be
    end

    it 'should return 0 if there are not previous frames' do
      bonus = Bonus.new(game, 1)

      expect(bonus.update).to eq(0)
    end
  end
end
