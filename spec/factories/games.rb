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

FactoryBot.define do
  factory :game do
    name { Faker::Name.name }
  end
end
