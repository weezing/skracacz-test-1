class Api::V1::LinksController < Api::V1::BaseController
  def create
    link = Link.create!(
      original_link: jsonapi_params[:original_link],
      slug: SecureRandom.hex(10)
    )
    render json: link.to_json, status: :created
  end
end
