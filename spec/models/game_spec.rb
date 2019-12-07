# == Schema Information
#
# Table name: games
#
#  id              :bigint           not null, primary key
#  name            :string
#  status          :integer          default("active")
#  total_score     :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  active_frame_id :bigint
#
# Indexes
#
#  index_games_on_active_frame_id  (active_frame_id)
#
# Foreign Keys
#
#  fk_rails_...  (active_frame_id => frames.id)
#

require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'associations' do
    it 'should have many frames' do
      should have_many(:frames).class_name('Frame')
    end

    it 'should belong to active_frame' do
      should belong_to(:active_frame).class_name('Frame').optional
    end
  end

  describe 'validations' do
    it 'should validate presence of name' do
      should validate_presence_of(:name)
    end

    it 'should validate presence of name' do
      should validate_presence_of(:status)
    end

    it 'allowed values for status' do
      should allow_value(:active).for(:status)
      should allow_value(:completed).for(:status)
    end
  end

  describe 'after_create' do
    it 'should create first frame' do
      game = create(:game)
      expect(game.frames.count).to eq(1)
      expect(game.active_frame).to be
    end
  end

  describe '#frame_by_number' do
    let(:game) { create(:game, frames: [create(:frame, number: 1), create(:frame, number: 2)]) }

    it 'should return frame number 1' do
      expect(game.frame_by_number(1).number).to eq(1)
    end

    it 'should return frame number 2' do
      expect(game.frame_by_number(2).number).to eq(2)
    end
  end
end
