class Api::V1::LinksController < Api::V1::BaseController
  def create
    link = Link.create!(create_params.merge(slug: SecureRandom.hex(10)))
    render json: link.to_json, status: :created
  end

  private

  def create_params
    jsonapi_params.permit(:original_link)
  end
end
