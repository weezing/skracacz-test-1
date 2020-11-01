class Link < ApplicationRecord
  validates :original_link, presence: true
  validates :slug, presence: true
end
