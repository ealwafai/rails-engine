require 'rails_helper'

RSpec.describe 'item merchant requests' do
  describe 'GET /items/:id/merchant' do
    context 'merchant exists and has items' do
      it 'returns a list of all merchant items' do
        merchant = create(:merchant, id: 1)
        item = create(:item, merchant: merchant, id: 1)

        get "/api/v1/items/#{item.id}/merchant"

        expect(response).to have_http_status(200)

        result = JSON.parse(response.body, symbolize_names: true)

        expect(result[:data]).to be_a(Hash)

        data = result[:data]
        expect(data[:id]).to eq(merchant.id.to_s)
        expect(data[:type]).to eq('merchant')
        expect(data[:attributes]).to be_a(Hash)

        expect(data[:attributes]).to have_key(:name)
        expect(data[:attributes][:name]).to eq(merchant.name)
      end
    end

    context 'item does not exist' do
      it 'returns an error message and 404 status code' do
        merchant = create(:merchant)

        get '/api/v1/items/123456/merchant'

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Item/)
      end
    end

    context 'invalid id is provided' do
      it 'returns an error message and 404 status code' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant)

        get '/api/v1/items/string/merchant'

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end
end
