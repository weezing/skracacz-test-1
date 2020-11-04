RSpec.describe Api::V1::LinksController, type: :request do
  describe '#create' do
    it 'creates a new link' do
      allow_any_instance_of(described_class)
        .to receive(:shortened_link_base_url).and_return('http://www.example.com/')

      params = {
        data: {
          type: 'links',
          attributes: {
            original_link: 'http://www.google.com'
          }
        }
      }

      post '/api/v1/links', params: params

      expect(response.status).to eq 201
      expect(Link.count).to eq 1

      link = Link.first

      expect(link.original_link).to eq('http://www.google.com')
      expect(link.slug).not_to be_empty

      data = ActiveSupport::JSON.decode(response.body)['data']

      expect(data['id']).to eq(link.id.to_s)
      expect(data['type']).to eq('links')
      expect(data['attributes']['original_link']).to eq(link.original_link)
      expect(data['attributes']['slug']).to eq(link.slug)

      links = ActiveSupport::JSON.decode(response.body)['links']

      expect(links['shortened_link']).to eq('http://www.example.com/' + link.slug)
    end

    it 'returns validation error for invalid params' do
      params = {
        data: {
          type: 'links',
          attributes: {
            original_link: 'www.google'
          }
        }
      }

      post '/api/v1/links', params: params

      expect(response.status).to eq 422
      errors = ActiveSupport::JSON.decode(response.body)['errors']
      expect(errors.count).to eq 1
      expect(errors.first['title']).to eq 'Validation Error'

      expect(Link.count).to eq 0
    end
  end

  describe '#destroy' do
    it 'deletes link' do
      link = create(:link, slug: 'sLuG99')

      delete "/api/v1/links/#{link.slug}?admin_api_key=adminapikey"

      expect(response.status).to eq(204)
      expect(Link.count).to eq(0)
    end

    it 'returns not found for improper link slug' do
      create(:link, slug: 'sLuG99')

      delete '/api/v1/links/wrongslug?admin_api_key=adminapikey'

      expect(response.status).to eq 404
      errors = ActiveSupport::JSON.decode(response.body)['errors']
      expect(errors.count).to eq 1
      expect(errors.first['title']).to eq 'Not Found'

      expect(Link.count).to eq(1)
    end

    it 'returns unauthorized error for bad admin api key provided' do
      link = create(:link, slug: 'someslug')

      delete '/api/v1/links/someslug?admin_api_key=wrongadminapikey'

      expect(response.status).to eq 401
      errors = ActiveSupport::JSON.decode(response.body)['errors']
      expect(errors.count).to eq 1
      expect(errors.first['title']).to eq 'Unauthorized'

      expect(Link.count).to eq(1)
    end

    it 'returns unauthorized error for no admin api key provided' do
      link = create(:link, slug: 'someslug')

      delete '/api/v1/links/someslug'

      expect(response.status).to eq 401
      errors = ActiveSupport::JSON.decode(response.body)['errors']
      expect(errors.count).to eq 1
      expect(errors.first['title']).to eq 'Unauthorized'

      expect(Link.count).to eq(1)
    end
  end
end
