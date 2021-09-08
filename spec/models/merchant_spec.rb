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
  end
end
