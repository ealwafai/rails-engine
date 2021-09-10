require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
  end
  describe 'class methods' do
    describe 'find_by_name' do
      it 'returns the first name in case insensitive, and alphabetical order' do
        merchant_1 = create(:merchant, name: 'Matt')
        merchant_2 = create(:merchant, name: 'Brett')
        merchant_3 = create(:merchant, name: 'Brian')

        expect(Merchant.find_by_name('Br')).to eq merchant_2
      end

      it 'returns an empty array if no matches found' do
        merchant_1 = create(:merchant, name: 'Matt')
        merchant_2 = create(:merchant, name: 'Brett')
        merchant_3 = create(:merchant, name: 'Brian')

        expect(Merchant.find_by_name('Sam')).to be_nil
      end
    end

    describe 'instance methods' do
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

      describe 'total_revenue' do
        it 'returns total revenue per merchant' do
          expect(@merchant_2.total_revenue.revenue).to eq(300.00)
        end

        it 'revenue from unshipped invoices and/or failed transactions is not calucalated' do
          expect(@merchant_1.total_revenue.revenue).to eq(250.00)
        end
      end
    end
  end
end
