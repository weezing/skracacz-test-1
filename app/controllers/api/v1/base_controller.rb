# frozen_string_literal: true

class Api::V1::BaseController < ActionController::API
  private

  def jsonapi_params
    params.require(:data).require(:attributes)
  end

  def render_error(code, title, options = {})
    error = { code: code, title: title }.merge(options)

    render(json: { errors: [error] }, status: code)
  end

  def render_validation_errors(object)
    render(json: { errors: ValidationSerializer.new(object).errors }, status: 422)
  end
end
