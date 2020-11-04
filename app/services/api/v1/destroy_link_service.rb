class Api::V1::DestroyLinkService
  def initialize(link)
    @link = link
  end

  def call
    delete_link
  end

  private

  attr_reader :link

  def delete_link
    link.destroy!
  end
end
