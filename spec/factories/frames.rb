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

FactoryBot.define do
  factory :frame do
    game
    sequence :number do |n|
      n % 10 + 1
    end
  end
end
