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
  include GameCore::Constants

  default_scope { order(number: :asc) }

  belongs_to :game

  validates :number, presence: true, inclusion: { in: ALLOWED_FRAMES, message: '%{value} out of frames range.' }
  validates :first_ball, inclusion: { in: :allowed_points, message: '%{value} out of points range.' }
  validates :second_ball, inclusion: { in: :allowed_points, message: '%{value} out of points range.' }
  validates :third_ball, inclusion: { in: :allowed_points, message: '%{value} out of points range.' }

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

  private
    def allowed_points
      ALLOWED_POINTS.to_a << nil
    end
end
