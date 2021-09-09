require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_greater_than(0.0) }
  end

  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
  end
  describe 'search_by_name' do
    it 'returns a list of matching items by name' do
      item_1 = create(:item, name: 'Book on North Star', merchant: @merchant_1)
      item_2 = create(:item, name: 'book on south star', merchant: @merchant_2)
      item_3 = create(:item, name: 'book on galaxies', description: 'galaxy formation', merchant: @merchant_2)

      expect(Item.search_by_name('star')).to be_an(Array)
      expect(Item.search_by_name('star').length).to eq(2)
      expect(Item.search_by_name('star').first).to eq(item_2)
      expect(Item.search_by_name('star').second).to eq(item_1)
      expect(Item.search_by_name('star')).not_to include(item_3)
    end

    it 'returns empty array if no matching items exist' do
      expect(Item.search_by_name('star')).to be_an(Array)
      expect(Item.search_by_name('star')).to(be_empty)
    end
  end

  describe 'search_by_price' do
    context 'both params are present' do
      it 'returns a list of matching items by price' do
        item_1 = create(:item, unit_price: 150.00, merchant: @merchant_1)
        item_2 = create(:item, unit_price: 120.00, merchant: @merchant_1)
        item_3 = create(:item, unit_price: 80.00, merchant: @merchant_2)
        item_4 = create(:item, unit_price: 50.00, merchant: @merchant_2)

        price_params = { min_price: 65, max_price: 155 }

        expect(Item.search_by_price(price_params)).to be_an(Array)
        expect(Item.search_by_price(price_params).length).to eq(3)
        expect(Item.search_by_price(price_params)).not_to include(item_4)
      end
    end

    context 'min_price is given' do
      it 'returns a list of items with higher prices than given param' do
        item_1 = create(:item, unit_price: 150.00, merchant: @merchant_1)
        item_2 = create(:item, unit_price: 120.00, merchant: @merchant_1)
        item_3 = create(:item, unit_price: 80.00, merchant: @merchant_2)
        item_4 = create(:item, unit_price: 50.00, merchant: @merchant_2)

        price_params = { min_price: 70, max_price: nil }

        expect(Item.search_by_price(price_params)).to be_an(Array)
        expect(Item.search_by_price(price_params).length).to eq(3)
        expect(Item.search_by_price(price_params)).not_to include(item_4)
      end
    end

    context 'only max_price is given' do
      it 'returns a list of lower prices than given param' do
        item_1 = create(:item, unit_price: 150.00, merchant: @merchant_1)
        item_2 = create(:item, unit_price: 120.00, merchant: @merchant_1)
        item_3 = create(:item, unit_price: 80.00, merchant: @merchant_2)
        item_4 = create(:item, unit_price: 170.00, merchant: @merchant_2)

        price_params = { min_price: nil, max_price: 155 }

        expect(Item.search_by_price(price_params)).to be_an(Array)
        expect(Item.search_by_price(price_params).length).to eq(3)

        expect(Item.search_by_price(price_params)).not_to include(item_4)
      end
    end

    it 'returns an empty array if no matching items are found' do
      expect(Item.search_by_name('star')).to be_an(Array)
      expect(Item.search_by_name('star')).to(be_empty)
    end
  end
end
