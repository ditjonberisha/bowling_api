require 'rails_helper'

RSpec.describe Api::V1::Games::BaseController, type: :controller do
  describe 'before action' do
    it 'should call set game' do
      should use_before_action(:set_game)
    end
  end
end
