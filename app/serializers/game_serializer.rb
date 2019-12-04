# == Schema Information
#
# Table name: games
#
#  id          :bigint           not null, primary key
#  name        :string
#  status      :integer          default(0)
#  total_score :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :total_score, :status
end
