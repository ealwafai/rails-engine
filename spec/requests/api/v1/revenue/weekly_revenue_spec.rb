require 'rails_helper'

RSpec.describe 'weekly revenue' do
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
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_2, unit_price: 30.00)

    @invoice_2 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'pending', created_at: Time.parse('2021-08-01'))
    @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success')
    @invoice_item_3 = create(:invoice_item, invoice: @invoice_2, item: @item_3, unit_price: 30.00)

    @invoice_3 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'shipped', created_at: Time.parse('2021-08-01'))
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'failure')
    @invoice_item_4 = create(:invoice_item, invoice: @invoice_3, item: @item_4, unit_price: 30.00)

    @invoice_4 = create(:invoice, customer: @customer, merchant: @merchant_2, created_at: Time.parse('2021-07-01'))
    @transaction_4 = create(:transaction, invoice: @invoice_4)
    @invoice_item_5 = create(:invoice_item, invoice: @invoice_4, item: @item_5, unit_price: 30.00)

    @invoice_5 = create(:invoice, customer: @customer, merchant: @merchant_2, created_at: Time.parse('2021-04-01'))
    @transaction_5 = create(:transaction, invoice: @invoice_5)
    @invoice_item_6 = create(:invoice_item, invoice: @invoice_5, item: @item_6, unit_price: 30.00)
  end

  it 'returns the revenue per week' do
    get '/api/v1/revenue/weekly'

    expect(response).to have_http_status(200)

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:data]).to be_an(Array)
    expect(result[:data].length).to eq(3)

    first_week = result[:data].first
    expect(first_week).to have_key(:id)
    expect(first_week).to have_key(:type)
    expect(first_week).to have_key(:attributes)
    expect(first_week[:attributes][:week]).to eq('2021-03-29')
    expect(first_week[:attributes][:revenue]).to eq(150.00)

    final_week = result[:data].last
    expect(final_week[:attributes][:week]).to eq('2021-08-30')
    expect(final_week[:attributes][:revenue]).to eq(250.00)
  end
end
