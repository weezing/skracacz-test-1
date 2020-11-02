class LinksController < ApplicationController
  def show
    link = Link.find_by(slug: params[:slug])

    redirect_to link.original_link, status: :moved_permanently
  end
end
