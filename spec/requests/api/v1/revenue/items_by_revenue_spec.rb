require 'rails_helper'

RSpec.describe 'Items by revenue' do
  context 'quantity is specified and valid' do
    it 'returns specified number of items ordered by revenue desc' do
      customer = create(:customer)
      create_list(:merchant, 3) do |merchant|
        create_list(:item, 5, merchant: merchant) do |item|
          invoice = create(:invoice, customer: customer, merchant: merchant)
          create(:invoice_item, invoice: invoice, item: item)
          create(:transaction, invoice: invoice)
        end
      end

      get '/api/v1/revenue/items', params: { quantity: 5 }

      expect(response).to have_http_status(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:data]).to be_an(Array)
      expect(result[:data].length).to eq(5)

      first_item = result[:data].first
      second_item = result[:data].second
      first_revenue = first_item[:attributes][:revenue]
      second_revenue = second_item[:attributes][:revenue]
      expect(first_revenue > second_revenue).to be true
    end
  end

  context 'quantity is specified but invalid' do
    it 'returns error message and 400 status code' do
      get '/api/v1/revenue/items', params: { quantity: -1 }

      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end

    it 'returns error message and 400 status code' do
      get '/api/v1/revenue/items', params: { quantity: 'string' }

      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end
  end

  context 'quantity is unspecified' do
    it 'returns top 10 items by revenue' do
      customer = create(:customer)
      create_list(:merchant, 3) do |merchant|
        create_list(:item, 5, merchant: merchant) do |item|
          invoice = create(:invoice, customer: customer, merchant: merchant)
          create(:invoice_item, invoice: invoice, item: item)
          create(:transaction, invoice: invoice)
        end
      end

      get '/api/v1/revenue/items'

      expect(response).to have_http_status(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:data]).to be_an(Array)
      expect(result[:data].length).to eq(10)

      first_item = result[:data].first
      expect(first_item).to have_key(:id)
      expect(first_item[:type]).to eq('item')
      expect(first_item[:attributes]).to be_a(Hash)

      expect(first_item[:attributes]).to have_key(:name)
      expect(first_item[:attributes]).to have_key(:description)
      expect(first_item[:attributes]).to have_key(:unit_price)
      expect(first_item[:attributes]).to have_key(:merchant_id)
      expect(first_item[:attributes]).to have_key(:revenue)

      second_item = result[:data].second
      first_revenue = first_item[:attributes][:revenue]
      second_revenue = second_item[:attributes][:revenue]

      expect(first_revenue > second_revenue).to be true
    end
  end
end
