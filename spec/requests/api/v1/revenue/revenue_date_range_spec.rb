require 'rails_helper'

RSpec.describe 'requests for total revenue within date range' do
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

    @invoice_1 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'shipped', created_at: Time.parse('2021-09-01'))
    @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success')
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 20.00)

    @invoice_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_2, unit_price: 25.00)

    @invoice_2 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'pending', created_at: Time.parse('2021-08-01'))
    @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success')
    @invoice_item_3 = create(:invoice_item, invoice: @invoice_2, item: @item_3, unit_price: 30.00)

    @invoice_3 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'shipped', created_at: Time.parse('2021-08-01'))
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'failure')
    @invoice_item_4 = create(:invoice_item, invoice: @invoice_3, item: @item_4, unit_price: 40.00)

    @invoice_4 = create(:invoice, customer: @customer, merchant: @merchant_2, created_at: Time.parse('2021-07-01'))
    @transaction_4 = create(:transaction, invoice: @invoice_4)
    @invoice_item_5 = create(:invoice_item, invoice: @invoice_4, item: @item_5, unit_price: 30.00)

    @invoice_5 = create(:invoice, customer: @customer, merchant: @merchant_2, created_at: Time.parse('2021-04-01'))
    @transaction_5 = create(:transaction, invoice: @invoice_5)
    @invoice_item_6 = create(:invoice_item, invoice: @invoice_5, item: @item_6, unit_price: 30.00)
  end

  context 'start and end dates are valid' do
    it 'returns the total revenue for a specific range' do
      get '/api/v1/revenue', params: {start: '2021-07-01', end: '2021-09-01'}

      expect(response).to have_http_status(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:data]).to be_a(Hash)
      expect(result[:data]).to have_key(:id)
      expect(result[:data]).to have_key(:attributes)

      expect(result[:data][:attributes][:revenue]).to eq(375.00)
    end
  end

  context 'start date is missing' do
    it 'returns an error message and 400 status code' do
      get '/api/v1/revenue', params: {end: '2021-09-01'}

      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end
  end

  context 'end date is missing' do
    it 'returns an error message and 400 status code' do
      get '/api/v1/revenue', params: {start: '2021-07-01'}

      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end
  end

  context 'start and end dates are missing' do
    it 'returns an error message and 400 status code' do
      get '/api/v1/revenue'

      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end
  end

  context 'date format is invalid' do
    it 'returns an error message and 400 status code' do
      get '/api/v1/revenue', params: {start: 'string', end: ''}

      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end
  end

  context 'start date comes after end date' do
    it 'returns an error message and 400 status code' do
      get '/api/v1/revenue', params: {start: '2021-09-01', end: '2021-07-01'}

      expect(response).to have_http_status(400)
      expect(response.body).to match(/Bad request/)
    end
  end
end
