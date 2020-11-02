describe Api::V1::CreateLinkForm do
  it 'valid' do
    expected_attributes = {
      original_link: 'https://www.google.com',
      slug: 'sLUg99'
    }
    params = {
      original_link: 'https://www.google.com',
      slug: 'sLUg99'
    }
    form = described_class.new(params)

    expect(form.valid?).to eq true
    expect(form.attributes).to eq(expected_attributes)
  end

  context 'invalid' do
    it 'original_link: presence' do
      params = {
        original_link: '',
        slug: 'sLUg99'
      }
      form = described_class.new(params)

      expect(form.valid?).to eq false
      expect(form.errors[:original_link]).to include("can't be blank")
    end

    it 'original_link: format' do
      params = {
        original_link: 'www.google',
        slug: 'sLUg99'
      }
      form = described_class.new(params)

      expect(form.valid?).to eq false
      expect(form.errors[:original_link]).to include('is not a valid URL')
    end

    it 'slug: presence' do
      params = {
        original_link: 'https://www.google.com',
        slug: ''
      }
      form = described_class.new(params)

      expect(form.valid?).to eq false
      expect(form.errors[:slug]).to include("can't be blank")
    end
  end
end
