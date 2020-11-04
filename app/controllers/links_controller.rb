class LinksController < ApplicationController
  def show
    link = Link.find_by(slug: params[:slug])

    render(file: "#{Rails.root}/public/404.html", status: :not_found) and return unless link

    redirect_to link.original_link, status: :moved_permanently
  end
end
