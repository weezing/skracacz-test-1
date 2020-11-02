class Api::V1::LinksController < Api::V1::BaseController
  def create
    slug = SlugGenerator.prepare_slug
    form = Api::V1::CreateLinkForm.new(create_params.merge(slug: slug))

    render_validation_errors(form) && return unless form.valid?

    service = Api::V1::CreateLinkService.new(form)

    if service.call
      link = service.link

      render json: LinksSerializer.new(
        link,
        links: { shortened_link: 'http://localhost:3000/' + link.slug }
      ), status: :created
    else
      render_error(422, service.error)
    end
  end

  private

  def create_params
    jsonapi_params.permit(:original_link)
  end
end
