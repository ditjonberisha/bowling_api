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

FactoryBot.define do
  factory :game do
    name { Faker::Name.name }

    after(:build) { |g| g.class.skip_callback(:create, :after, :init_first_frame, raise: false) }

    factory :game_with_callbacks do
      after(:create) { |g| g.send(:init_first_frame) }
    end
  end
end
