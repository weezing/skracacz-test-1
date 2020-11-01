RSpec.describe Api::V1::LinksController, type: :request do
  describe '#create' do
    it 'creates a new link' do
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
      expect(data['links']['self']).to eq('http://localhost:3000/' + link.slug)
    end

    it 'returns validation error for invalid params' do
      params = {
        data: {
          type: 'links',
          attributes: {
            original_link: 'http://www.google'
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
end
