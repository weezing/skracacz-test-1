class Api::V1::LinksController < Api::V1::BaseController
  def create
    form = Api::V1::CreateLinkForm.new(create_params.merge(slug: SecureRandom.hex(10)))
    service = Api::V1::CreateLinkService.new(form)

    if service.call
      render json: service.link.to_json, status: :created
    else
      render_error(422, 'Validation Error')
    end
  end

  private

  def create_params
    jsonapi_params.permit(:original_link)
  end
end
