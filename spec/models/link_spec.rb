RSpec.describe Link, type: :model do
  it 'is valid with valid attributes' do
    link = Link.new(
      original_link: 'https://www.google.com',
      slug: 'zxcVB9'
    )

    expect(link).to be_valid
  end

  it 'has a valid factory' do
    slug = 'slug99'

    expect{ create(:link, slug: slug) }.to change(Link, :count).by(1)
    expect(Link.last.slug).to eq(slug)
  end
end
