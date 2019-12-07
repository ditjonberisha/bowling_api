module Api::V1::Helpers
  module Render
    extend ActiveSupport::Concern

    def serialize_object(object, serializer, _status = nil)
      render json: object, serializer: serializer, status: _status || 200
    end

    def json_response(result, _status = nil)
      json = { status: _status || 200, result: result }.as_json

      render json: json, status: _status || 200
    end
  end
end
