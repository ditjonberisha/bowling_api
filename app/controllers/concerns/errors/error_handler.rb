module Errors
  module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError do |e|
        respond(:standard_error, 500, e.to_s)
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        respond(:record_invalid, 400, e.record.errors.full_messages)
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        respond(:record_not_found, 404, e.to_s)
      end

      rescue_from ActionController::ParameterMissing do |e|
        respond(:parameter_missing, 400, "#{e.param} parameter is required")
      end

      rescue_from Errors::GameError do |e|
        respond(e.error, e.status, e.message)
      end
    end

    private
      def respond(_error, _status, _message)
        json = Errors::Helpers::ErrorRender.json(_error, _status, _message)
        render json: json, status: _status
      end
  end
end
