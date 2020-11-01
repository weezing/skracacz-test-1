RSpec.describe Link, type: :model do
  it 'is valid with valid attributes' do
    link = Link.new(
      original_link: 'https://www.google.com',
      slug: 'zxcVB9'
    )

    expect(link).to be_valid
  end

  it 'is not valid without an original link' do
    link = Link.new(
      original_link: '',
      slug: 'zxcVB9'
    )

    expect(link).not_to be_valid
  end

  it 'is not valid without a slug' do
    link = Link.new(
      original_link: 'https://www.google.com',
      slug: ''
    )

    expect(link).not_to be_valid
  end

  it 'has a valid factory' do
    slug = 'slug99'

    expect{ create(:link, slug: slug) }.to change(Link, :count).by(1)
    expect(Link.last.slug).to eq(slug)
  end
end
