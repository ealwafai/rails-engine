require 'rails_helper'

RSpec.describe 'merchant items requests' do
  describe 'GET /merchants/:id/items' do
    context 'merchant exists and has items' do
      it 'returns a list of all merchant items' do
        merchant = create(:merchant)
        item = create_list(:item, 25, merchant: merchant)

        get "/api/v1/merchants/#{merchant.id}/items"

        expect(response).to have_http_status(200)

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(25)

        items[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id]).to be_an(String)

          expect(item).to have_key(:type)
          expect(item[:type]).to eq("item")

          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to be_an(String)

          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes][:description]).to be_an(String)

          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to be_an(Float)

          expect(item[:attributes]).to have_key(:merchant_id)
          expect(item[:attributes][:merchant_id]).to be_an(Integer)
        end
      end
    end

    context 'merchant exists but has no items' do
      it 'returns a 200 status code and data is an empty array' do
        merchant = create(:merchant)

        get "/api/v1/merchants/#{merchant.id}/items"

        expect(response).to have_http_status(200)

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data]).to eq([])
      end
    end

    context 'merchant does not exist' do
      it 'returns an error message and 404 status code' do
        get "/api/v1/merchants/123456/items"

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Merchant/)
      end
    end
  end
end
