require 'rails_helper'

RSpec.describe 'Merchants API Requests' do
  describe 'GET /merchants' do
    context 'params are not specified' do
      it 'sends a list of first 20 merchants with default params' do
        create_list(:merchant, 30)

        get '/api/v1/merchants'

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(20)

        merchants[:data].each do |merchant|
          expect(merchant).to have_key(:id)
          expect(merchant[:id]).to be_an(String)

          expect(merchant).to have_key(:type)
          expect(merchant[:type]).to eq('merchant')

          expect(merchant).to have_key(:attributes)
          expect(merchant[:attributes]).to be_a(Hash)

          expect(merchant[:attributes]).to have_key(:name)
          expect(merchant[:attributes][:name]).to be_an(String)
        end
      end
    end

    context 'params are present' do
      context 'and only per_page is specified' do
        it 'sends the appropriate list length and defaults to page 1' do
          create_list(:merchant, 30)

          all_merchants = Merchant.all

          get '/api/v1/merchants', params: { per_page: 10 }

          merchants = JSON.parse(response.body, symbolize_names: true)

          expect(merchants[:data].count).to eq(10)
          expect(merchants[:data].first[:id]).to eq(all_merchants.first.id.to_s)
          expect(merchants[:data].last[:id]).to eq(all_merchants[9].id.to_s)

          merchants[:data].each do |merchant|
            expect(merchant).to have_key(:id)
            expect(merchant[:id]).to be_an(String)

            expect(merchant).to have_key(:type)
            expect(merchant[:type]).to eq('merchant')

            expect(merchant).to have_key(:attributes)
            expect(merchant[:attributes]).to be_a(Hash)

            expect(merchant[:attributes]).to have_key(:name)
            expect(merchant[:attributes][:name]).to be_an(String)
          end
        end
      end

      context 'and only page is specified' do
        it 'sends the correct items for page and defaults to 20 per page' do
          create_list(:merchant, 30)

          all_merchants = Merchant.all

          get '/api/v1/merchants', params: { page: 2 }

          merchants = JSON.parse(response.body, symbolize_names: true)

          expect(merchants[:data].count).to eq(10)
          expect(merchants[:data].first[:id]).to eq(all_merchants[20].id.to_s)
          expect(merchants[:data].last[:id]).to eq(all_merchants.last.id.to_s)

          merchants[:data].each do |merchant|
            expect(merchant).to have_key(:id)
            expect(merchant[:id]).to be_an(String)

            expect(merchant).to have_key(:type)
            expect(merchant[:type]).to eq('merchant')

            expect(merchant).to have_key(:attributes)
            expect(merchant[:attributes]).to be_a(Hash)

            expect(merchant[:attributes]).to have_key(:name)
            expect(merchant[:attributes][:name]).to be_an(String)
          end
        end

        it 'defaults to page 1 if page param is specified as < 1' do
          create_list(:merchant, 30)

          all_merchants = Merchant.all

          get '/api/v1/merchants', params: { page: -1 }

          merchants = JSON.parse(response.body, symbolize_names: true)

          expect(merchants[:data].count).to eq(20)
          expect(merchants[:data].first[:id]).to eq(all_merchants.first.id.to_s)
          expect(merchants[:data].last[:id]).to eq(all_merchants[19].id.to_s)

          merchants[:data].each do |merchant|
            expect(merchant).to have_key(:id)
            expect(merchant[:id]).to be_an(String)

            expect(merchant).to have_key(:type)
            expect(merchant[:type]).to eq('merchant')

            expect(merchant).to have_key(:attributes)
            expect(merchant[:attributes]).to be_a(Hash)

            expect(merchant[:attributes]).to have_key(:name)
            expect(merchant[:attributes][:name]).to be_an(String)
          end
        end
      end

      context 'and both params are specified' do
        it 'sends the appropriate items and list length for the params' do
          create_list(:merchant, 30)

          all_merchants = Merchant.all

          get '/api/v1/merchants', params: { page: 2, per_page: 10 }

          merchants = JSON.parse(response.body, symbolize_names: true)

          expect(merchants[:data].count).to eq(10)
          expect(merchants[:data].first[:id]).to eq(all_merchants[10].id.to_s)
          expect(merchants[:data].last[:id]).to eq(all_merchants[19].id.to_s)

          merchants[:data].each do |merchant|
            expect(merchant).to have_key(:id)
            expect(merchant[:id]).to be_an(String)

            expect(merchant).to have_key(:type)
            expect(merchant[:type]).to eq('merchant')

            expect(merchant).to have_key(:attributes)
            expect(merchant[:attributes]).to be_a(Hash)

            expect(merchant[:attributes]).to have_key(:name)
            expect(merchant[:attributes][:name]).to be_an(String)
          end
        end
      end
    end

    context 'when no data is available' do
      it 'returns an empty array' do
        get '/api/v1/merchants'

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data]).to eq([])
      end
    end
  end

  describe 'GET merchants/:id' do
    context 'merchant exists' do
      it 'returns the specific merchant details' do
        merchant_1 = create(:merchant)

        get "/api/v1/merchants/#{merchant_1.id}"

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(merchant[:data]).to be_a Hash

        data = merchant[:data]
        expect(data[:id]).to eq(merchant_1.id.to_s)
        expect(data[:type]).to eq('merchant')
        expect(data[:attributes]).to be_a(Hash)

        expect(data[:attributes]).to have_key(:name)
        expect(data[:attributes][:name]).to be_an(String)
      end
    end

    context 'merchant does not exist' do
      it 'returns a status code 404' do
        get '/api/v1/merchants/123456'

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Merchant/)
      end
    end

    context 'request is not valid' do
      it 'returns a status code 404' do
        get '/api/v1/merchants/whatever'

        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Merchant/)
      end
    end
  end
end
