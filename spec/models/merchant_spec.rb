require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name)}
  end

  describe 'class methods' do
    let!(:merchant_1) {Merchant.create!(name: 'Claires')}
    let!(:merchant_2) {Merchant.create!(name: 'Claires 2')}
    let!(:merchant_3) {Merchant.create!(name: 'Spencers')}
    let!(:merchant_4) {Merchant.create!(name: 'Hot Topic')}
    let!(:merchant_5) {Merchant.create!(name: 'Hot Sneakers')}
    it 'returns all merchants that match the search criteria' do
      expect(Merchant.search_by_name('hot')).to eq([merchant_4, merchant_5])
    end

    it 'returns an empty array if no merchants match the criteria' do
      expect(Merchant.search_by_name('Icing')).to eq([])
    end

    it 'returns a merchant name regardless of casing' do
      expect(Merchant.search_by_name('tOPic')).to eq([merchant_4])
    end
  end
end
