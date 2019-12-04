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

require 'rails_helper'

RSpec.describe Game, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
