class Api::V1::BaseController < ApplicationController
  include Errors::ErrorHandler
  include Helpers::Render
end
