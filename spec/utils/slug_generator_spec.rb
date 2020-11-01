RSpec.describe SlugGenerator do
  it 'prepares correct slug' do
    regex = /\b[a-zA-Z0-9]{6}\b/

    slug = described_class.prepare_slug

    expect(slug).to match(regex)
  end
end
