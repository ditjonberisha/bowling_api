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

class CreateGameSerializer < ActiveModel::Serializer
  attributes :id, :name, :status
end
