# == Schema Information
#
# Table name: frames
#
#  id          :bigint           not null, primary key
#  first_ball  :integer
#  number      :integer
#  second_ball :integer
#  status      :integer          default("normal")
#  third_ball  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  game_id     :bigint
#
# Indexes
#
#  index_frames_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#

require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe 'associations' do
    it 'should belong to game' do
      should belong_to(:game).class_name('Game')
    end
  end

  describe 'validations' do
    it 'should validate presence and inclusion of number' do
      should validate_presence_of(:number)
      should validate_inclusion_of(:number).in_range(1..10).with_message(/. out of frames range./)
    end

    it 'should validate inclusion of first_ball' do
      should validate_inclusion_of(:first_ball).in_array([nil, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).with_message(/. out of points range./)
    end

    it 'should validate inclusion of second_ball' do
      should validate_inclusion_of(:second_ball).in_array([nil, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).with_message(/. out of points range./)
    end

    it 'should validate inclusion of third_ball' do
      should validate_inclusion_of(:third_ball).in_array([nil, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).with_message(/. out of points range./)
    end

    it 'allowed values for status' do
      should allow_value(:normal).for(:status)
      should allow_value(:spare).for(:status)
      should allow_value(:strike).for(:status)
    end
  end

  describe '#score' do
    it 'should return score of the frame' do
      frame = build(:frame, first_ball: 1, second_ball: 2, third_ball: 3)
      expect(frame.score).to eq(6)

      frame = build(:frame, first_ball: 10, second_ball: 10, third_ball: 10)
      expect(frame.score).to eq(30)

      frame = build(:frame, first_ball: 5, second_ball: 4, third_ball: 0)
      expect(frame.score).to eq(9)
    end
  end

  describe '#next_shot' do
    it 'should return next shot' do
      frame = build(:frame)

      expect(frame.next_shot).to eq(:first_ball)

      frame.first_ball = 1
      expect(frame.next_shot).to eq(:second_ball)

      frame.second_ball = 1
      frame.status = :strike
      expect(frame.next_shot).to eq(:third_ball)
    end

    it 'should return nil' do
      frame = build(:frame, first_ball: 1, second_ball: 1, third_ball: 1)
      expect(frame.next_shot).to eq(nil)
    end
  end
end
