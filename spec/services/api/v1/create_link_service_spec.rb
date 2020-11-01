describe Api::V1::CreateLinkService do
  it 'call: create shortened link' do
    original_link = 'https://www.google.com'
    slug = 'sLUg99'
    form = double(
      valid?: true,
      attributes: {
        original_link: original_link,
        slug: slug
      }
    )

    service = described_class.new(form)
    expect { service.call }.to change(Link, :count).by(1)

    link = Link.last
    expect(link.original_link).to eq(original_link)
    expect(link.slug).to eq(slug)
  end

  it 'invalid form' do
    form = double(
      valid?: false
    )

    service = described_class.new(form)
    expect(service.call).to eq(false)
    expect { service.call }.to change(Link, :count).by(0)
  end
end
