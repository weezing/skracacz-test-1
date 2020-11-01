module SlugGenerator
  CHARS_COUNT = 6

  def self.prepare_slug
    loop do
      new_slug = generate_slug
      break new_slug if Link.where(slug: new_slug).none?
    end
  end

  private

  def self.generate_slug
    charset = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a

    charset.sample(CHARS_COUNT).join
  end
end
