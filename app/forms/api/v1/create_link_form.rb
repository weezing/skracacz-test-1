class Api::V1::CreateLinkForm
  include ActiveModel::Model

  attr_accessor :original_link, :slug

  validates :original_link, presence: true
  validates :slug, presence: true

  def attributes
    {
      original_link: original_link,
      slug: slug
    }
  end
end
