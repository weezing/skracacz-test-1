class LinksSerializer
  include FastJsonapi::ObjectSerializer

  attributes :original_link, :slug
end
