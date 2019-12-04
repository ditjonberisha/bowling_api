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

class Game < ApplicationRecord
  has_many :frames, dependent: :destroy
  belongs_to :active_frame, class_name: 'Frame', optional: true

  validates :name, :status, presence: true

  enum status: %i[active completed]

  after_create :init_first_frame

  private
    def init_first_frame
      frame = frames.create!(number: 1)

      update(active_frame: frame)
    end
end
