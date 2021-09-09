require 'rails_helper'

RSpec.describe 'search items' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
  end

  describe 'GET /api/v1/items/find_all' do
    context 'search by name and/or description' do
      context 'matches are found' do
        it 'returns items matching that search by name or description' do
          item_1 = create(:item, name: 'Book on North Star', merchant: @merchant_1)
          item_2 = create(:item, name: 'book on south star', merchant: @merchant_2)
          item_3 = create(:item, name: 'book on galaxies', merchant: @merchant_2)

          get '/api/v1/items/find_all', params: { name: 'star' }

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_an(Array)
          expect(result[:data].length).to eq(2)

          first_item = result[:data].first
          expect(first_item[:id]).to eq(item_2.id.to_s)
          expect(first_item[:type]).to eq('item')
          expect(first_item[:attributes][:name]).to eq(item_2.name)

          second_item = result[:data].second
          expect(second_item[:id]).to eq(item_1.id.to_s)
          expect(second_item[:type]).to eq('item')
          expect(second_item[:attributes][:name]).to eq(item_1.name)
        end
      end

      context 'no matches found' do
        it 'returns a 200 status code and empty array' do
          get '/api/v1/items/find_all', params: { name: 'star' }

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_an(Array)
          expect(result[:data]).to be_empty
        end
      end
    end

    context 'searching by price' do
      context 'min price is present' do
        it 'returns items higher than that price' do
          item_1 = create(:item, unit_price: 150.00, merchant: @merchant_1)
          item_2 = create(:item, unit_price: 120.00, merchant: @merchant_1)
          item_3 = create(:item, unit_price: 85.00, merchant: @merchant_2)
          item_4 = create(:item, unit_price: 40.00, merchant: @merchant_2)

          get '/api/v1/items/find_all', params: { min_price: 70 }

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_an(Array)
          expect(result[:data].length).to eq(3)
        end
      end

      context 'and only max price is present' do
        it 'returns all items below that price' do
          item_1 = create(:item, unit_price: 160.00, merchant: @merchant_1)
          item_2 = create(:item, unit_price: 120.00, merchant: @merchant_1)
          item_3 = create(:item, unit_price: 85.00, merchant: @merchant_2)
          item_4 = create(:item, unit_price: 200.00, merchant: @merchant_2)

          get '/api/v1/items/find_all', params: { max_price: 150 }

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_an(Array)
          expect(result[:data].length).to eq(2)
        end
      end

      context 'and both params are present' do
        it 'returns all items between the listed prices' do
          item_1 = create(:item, unit_price: 145.00, merchant: @merchant_1)
          item_2 = create(:item, unit_price: 120.00, merchant: @merchant_1)
          item_3 = create(:item, unit_price: 90.00, merchant: @merchant_2)
          item_4 = create(:item, unit_price: 60.00, merchant: @merchant_2)

          get '/api/v1/items/find_all', params: { min_price: 70, max_price: 150 }

          expect(response).to have_http_status(200)

          result = JSON.parse(response.body, symbolize_names: true)

          expect(result[:data]).to be_an(Array)
          expect(result[:data].length).to eq(3)
        end
      end
    end

    context 'search with both sets of params' do
      it 'returns an error and 400 status code' do
        item = create(:item, name: 'Gourd of the Rings', merchant: @merchant_1)

        get '/api/v1/items/find_all', params: { name: 'star', max_price: 100.00 }

        expect(response).to have_http_status(400)
      end
    end

    context 'params are empty' do
      it 'returns an error and 400 status code' do
        item = create(:item, name: 'Book on North Star', merchant: @merchant_1)

        get '/api/v1/items/find_all', params: { name: nil }

        expect(response).to have_http_status(400)
      end
    end
  end
end
