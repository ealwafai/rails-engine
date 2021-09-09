require 'rails_helper'

RSpec.describe Invoice do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'class methods' do
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

      @invoice_4 = create(:invoice, customer: @customer, merchant: @merchant_2, created_at: Time.parse('2021-07-01'))
      @transaction_4 = create(:transaction, invoice: @invoice_4)
      @invoice_item_5 = create(:invoice_item, invoice: @invoice_4, item: @item_5, unit_price: 30.00)

      @invoice_5 = create(:invoice, customer: @customer, merchant: @merchant_2, created_at: Time.parse('2021-04-01'))
      @transaction_5 = create(:transaction, invoice: @invoice_5)
      @invoice_item_6 = create(:invoice_item, invoice: @invoice_5, item: @item_6, unit_price: 30.00)
    end

    describe 'revenue_per_range' do
      it 'returns total revenue for a given range' do
        start_date = '2021-07-01'
        end_date = '2021-09-01'

        expect(Invoice.revenue_per_range(start_date, end_date)).to eq(400.00)
      end

      it 'revenue for unshipped invoices are not included ' do
        invoice_2 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'pending', created_at: Time.parse('2021-08-01'))
        transaction_2 = create(:transaction, invoice: invoice_2, result: 'success')
        invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: @item_3, unit_price: 30.00)

        start_date = '2021-07-15'
        end_date = '2021-08-15'

        expect(Invoice.revenue_per_range(start_date, end_date)).to eq(0.00)
      end

      it 'does not include revenue for invoices without a good transaction' do
        invoice_3 = create(:invoice, customer: @customer, merchant: @merchant_1, status: 'shipped', created_at: Time.parse('2021-08-01'))
        transaction_3 = create(:transaction, invoice: invoice_3, result: 'failure')
        invoice_item_4 = create(:invoice_item, invoice: invoice_3, item: @item_4, unit_price: 30.00)

        start_date = '2021-07-15'
        end_date = '2021-08-15'

        expect(Invoice.revenue_per_range(start_date, end_date)).to eq(0.00)
      end
    end
  end
end
