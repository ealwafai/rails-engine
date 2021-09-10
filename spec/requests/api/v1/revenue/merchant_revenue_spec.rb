require 'rails_helper'

RSpec.describe 'total revenue for each merchant' do
  before :each do
    @customer = create(:customer)
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_1)
    @item_4 = create(:item, merchant: @merchant_1)
    @item_5 = create(:item, merchant: @merchant_2)
    @item_6 = create(:item, merchant: @merchant_2)

    @invoice_1 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'shipped')
    @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success')
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 20.00)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_2, unit_price: 30.00)

    @invoice_2 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'pending')
    @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success')
    @invoice_item_3 = create(:invoice_item, invoice: @invoice_2, item: @item_3, unit_price: 30.00)

    @invoice_3 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'shipped')
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'failure')
    @invoice_item_4 = create(:invoice_item, invoice: @invoice_3, item: @item_4, unit_price: 30.00)

    @invoice_4 = create(:invoice, customer: @customer, merchant: @merchant_2)
    @transaction_4 = create(:transaction, invoice: @invoice_4)
    @invoice_item_5 = create(:invoice_item, invoice: @invoice_4, item: @item_5, unit_price: 30.00)

    @invoice_5 = create(:invoice, customer: @customer, merchant: @merchant_2)
    @transaction_5 = create(:transaction, invoice: @invoice_5)
    @invoice_item_6 = create(:invoice_item, invoice: @invoice_5, item: @item_6, unit_price: 30.00)
  end

  context 'valid merchant' do
    it 'returns the total revenue per merchant' do
      get "/api/v1/revenue/merchants/#{@merchant_1.id}"

      expect(response).to have_http_status(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:data]).to be_a(Hash)
      expect(result[:data][:id]).to eq(@merchant_1.id.to_s)
      expect(result[:data][:type]).to eq('merchant_revenue')
      expect(result[:data][:attributes]).to be_a(Hash)

      attributes = result[:data][:attributes]
      expect(attributes[:revenue]).to eq(250.00)
    end
  end

  context 'invalid merchant id' do
    it 'returns error message and 404 status code' do
      get '/api/v1/revenue/merchants/string'

      expect(response).to have_http_status(404)
      expect(response.body).to match(/Couldn't find Merchant/)
    end
  end

  context 'merchant not found' do
    it 'returns error message and 404 status code' do
      get '/api/v1/revenue/merchants/123456'

      expect(response).to have_http_status(404)
      expect(response.body).to match(/Couldn't find Merchant/)
    end
  end
end
