class FrameSerializer < ActiveModel::Serializer
  attributes :number, :first_ball, :second_ball, :third_ball, :status, :score
end
