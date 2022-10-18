require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe 'class methods' do
    describe 'find_by_merchant' do
      let!( :merchants ) { create_list(:merchant, 3) }
      let!( :items ) { create_list(:item, 3, merchant: merchants[0]) }
      let!( :item_4 ) { create(:item, merchant: merchants[1]) }

      it 'returns all items for a specific merchant' do
        expect(Item.find_by_merchant(merchants[0].id)).to eq([items[0], items[1], items[2]])
      end

      it 'returns an empty array if a merchant has no items' do
        expect(Item.find_by_merchant(merchants[2].id)).to eq([])
      end
    end
  end
end
