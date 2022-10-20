require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_numericality_of(:unit_price).is_greater_than(0)}
  end

  describe 'class methods' do
    describe '.item_by_name(name)' do
      let!(:merchant) {create(:merchant)}
      let!(:item_1) { Item.create!(name: "Coffee Mug", description: "Keeps things warm", unit_price: 19.99, merchant_id: merchant.id)}
      let!(:item_2) { Item.create!(name: "Mr Coffee", description: "Brews coffee", unit_price: 29.99, merchant_id: merchant.id)}

      it 'returns a single item which matches a search term, if more than one is returned the first alphabetically is returned' do
        expect(Item.item_by_name("coffee")).to eq(item_1)
      end

      it 'returns a single item regardless of casing' do
        expect(Item.item_by_name("cOFFEe")).to eq(item_1)
      end

      it 'returns nil if no item matches the search criteria' do
        expect(Item.item_by_name("beans")).to eq(nil)
      end
    end

    describe '.min_price' do
      let!(:merchant) {create(:merchant)}
      let!(:item_1) { Item.create!(name: "Coffee Mug", description: "Keeps things warm", unit_price: 19.99, merchant_id: merchant.id)}
      let!(:item_2) { Item.create!(name: "Mr Coffee", description: "Brews coffee", unit_price: 55.00, merchant_id: merchant.id)}
      let!(:item_3) { Item.create!(name: "Mx Coffee", description: "Brews coffee", unit_price: 65.00, merchant_id: merchant.id)}

      it 'returns a single item which matches a minimum price given, if more than one is returned the first alphabetically is returned' do
        expect(Item.min_price(50.5)).to eq(item_2)
      end

      it 'returns nil if no item matches the search criteria' do
        expect(Item.min_price(75)).to eq(nil)
      end
    end

    describe '.max_price' do
      let!(:merchant) {create(:merchant)}
      let!(:item_1) { Item.create!(name: "Coffee Mug", description: "Keeps things warm", unit_price: 19.99, merchant_id: merchant.id)}
      let!(:item_2) { Item.create!(name: "Mr Coffee", description: "Brews coffee", unit_price: 55.00, merchant_id: merchant.id)}
      let!(:item_3) { Item.create!(name: "Mx Coffee", description: "Brews coffee", unit_price: 65.00, merchant_id: merchant.id)}

      it 'returns a single item which matches a maximum price given, if more than one is returned the first alphabetically is returned' do
        expect(Item.max_price(55)).to eq(item_1)
      end

      it 'returns nil if no item matches the search criteria' do
        expect(Item.max_price(10)).to eq(nil)
      end
    end

    describe '.min_and_max_price' do
      let!(:merchant) {create(:merchant)}
      let!(:item_1) { Item.create!(name: "Coffee Mug", description: "Keeps things warm", unit_price: 19.99, merchant_id: merchant.id)}
      let!(:item_2) { Item.create!(name: "Mr Coffee", description: "Brews coffee", unit_price: 55.00, merchant_id: merchant.id)}
      let!(:item_3) { Item.create!(name: "Mx Coffee", description: "Brews coffee again", unit_price: 65.00, merchant_id: merchant.id)}
      let!(:item_4) { Item.create!(name: "French Press", description: "Brews coffee also", unit_price: 25.00, merchant_id: merchant.id)}

      it 'returns a single item which matches a minimum and maximum price given, if more than one is returned the first alphabetically is returned' do
        expect(Item.min_and_max_price(19.99, 26.50)).to eq(item_1)
        expect(Item.min_and_max_price(20, 30.50)).to eq(item_4)
      end

      it 'returns nil if no item matches the search criteria' do
        expect(Item.min_and_max_price(3, 10)).to eq(nil)
      end
    end
  end
end

