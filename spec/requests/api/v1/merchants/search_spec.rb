require 'rails_helper'

RSpec.describe 'search merchants' do
  describe 'GET /api/v1/merchants/find' do
    context 'at least one merchant that matches' do
      context 'only one match' do
        it 'returns the single match' do
          merchant_1 = create(:merchant, name: 'Matt')
          merchant_2 = create(:merchant, name: 'Brett')
          merchant_3 = create(:merchant, name: 'Brian')

          get "/api/v1/merchants/find", params: { name: 'Bre'}

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_a Hash

          data = result[:data]
          expect(data[:id]).to eq merchant_2.id.to_s
          expect(data[:type]).to eq "merchant"
          expect(data[:attributes]).to be_a Hash

          expect(data[:attributes]).to have_key(:name)
          expect(data[:attributes][:name]).to eq merchant_2.name
        end
      end

      context 'multiple possible matches' do
        it 'returns the single match that comes first in case-insensitive order' do
          merchant_1 = create(:merchant, name: 'Matt')
          merchant_2 = create(:merchant, name: 'Brett')
          merchant_3 = create(:merchant, name: 'Brian')

          get "/api/v1/merchants/find", params: { name: 'br'}

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_a Hash

          data = result[:data]
          expect(data[:id]).to eq merchant_2.id.to_s
          expect(data[:type]).to eq "merchant"
          expect(data[:attributes]).to be_a Hash

          expect(data[:attributes]).to have_key(:name)
          expect(data[:attributes][:name]).to eq merchant_2.name
        end
      end
    end

    context 'no merchant search matches' do
      it 'returns an empty json response and status code 200' do
        merchant_1 = create(:merchant, name: 'Matt')
        merchant_2 = create(:merchant, name: 'Brett')
        merchant_3 = create(:merchant, name: 'Brian')

        get "/api/v1/merchants/find", params: { name: 'Sam'}

        expect(response).to have_http_status(200)

        result = JSON.parse(response.body, symbolize_names: true)

        expect(result).to be_a Hash
        expect(result).to have_key :data
        expect(result[:data]).to be_empty
      end
    end
  end
end
