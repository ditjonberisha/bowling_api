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

class FrameSerializer < ActiveModel::Serializer
  attributes :number, :first_ball, :second_ball, :third_ball, :status, :score
end
