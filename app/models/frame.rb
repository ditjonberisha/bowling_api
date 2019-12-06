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

class Frame < ApplicationRecord
  default_scope { order(number: :asc) }

  belongs_to :game

  enum status: %i[normal spare strike]

  def score
    first_ball.to_i + second_ball.to_i + third_ball.to_i
  end

  def next_shot
    return :first_ball if first_ball.nil?
    return :second_ball if second_ball.nil?
    return :third_ball if third_ball.nil? && (strike? || spare?)
    nil
  end
end
