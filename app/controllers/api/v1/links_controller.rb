class Api::V1::LinksController < Api::V1::BaseController
  before_action :authenticate_admin, only: :destroy

  def create
    slug = SlugGenerator.prepare_slug
    form = Api::V1::CreateLinkForm.new(create_params.merge(slug: slug))

    render_validation_errors(form) && return unless form.valid?

    service = Api::V1::CreateLinkService.new(form)

    if service.call
      link = service.link

      render json: LinksSerializer.new(
        link,
        links: {
          shortened_link: shortened_link_base_url + link.slug
        }
      ), status: :created
    else
      render_error(422, service.error)
    end
  end

  def destroy
    link = Link.find_by(slug: params[:id])

    render_error(404, 'Not Found') and return unless link

    service = Api::V1::DestroyLinkService.new(link)

    if service.call
      render(nothing: true, status: :no_content)
    else
      render_error(400, 'Bad Request')
    end
  end

  private

  def authenticate_admin
    render_error(401, 'Unauthorized') and return unless
      params[:admin_api_key] && params[:admin_api_key] == admin_api_key
  end

  def admin_api_key
    ENV['admin_api_key'] || Rails.application.credentials[Rails.env.to_sym][:admin_api_key]
  end

  def create_params
    jsonapi_params.permit(:original_link)
  end

  def shortened_link_base_url
    Rails.application.credentials[Rails.env.to_sym][:shortener_base_url].to_s
  end
end
