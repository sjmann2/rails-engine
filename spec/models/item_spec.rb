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
    describe '.find_one_item(name)' do
      let!(:merchant) {create(:merchant)}
      let!(:item_1) { Item.create!(name: "Coffee Mug", description: "Keeps things warm", unit_price: 19.99, merchant_id: merchant.id)}
      let!(:item_2) { Item.create!(name: "Mr Coffee", description: "Brews coffee", unit_price: 29.99, merchant_id: merchant.id)}

      it 'returns a single item which matches a search term, if more than one is returned the first alphabetically is returned' do
        expect(Item.find_one_item("coffee")).to eq(item_1)
      end

      it 'returns nil if no item matches the search criteria' do
        expect(Item.find_one_item("beans")).to eq(nil)
        #maybe change this so it returns something other than nil
      end
    end
  end
end

