require 'rails_helper'

describe 'Items API' do
  describe 'GET /items' do
    it 'returns items' do
      merchant = create_list(:merchant, 3)
      create_list(:item, 3, merchant: merchant[0])
      create_list(:item, 4, merchant: merchant[1])
      create_list(:item, 5, merchant: merchant[2])

      get '/api/v1/items'

      expect(response).to be_successful
      expect(response).to have_http_status(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(12)

      items.each do |item|
        expect(item[1][0]).to have_key(:id)
        expect(item[1][0][:attributes]).to have_key(:name)
        expect(item[1][0][:attributes][:name]).to be_a(String)
        expect(item[1][0][:attributes]).to have_key(:description)
        expect(item[1][0][:attributes][:description]).to be_a(String)
        expect(item[1][0][:attributes]).to have_key(:unit_price)
        expect(item[1][0][:attributes][:unit_price]).to be_a(Float)
      end
    end
    
    describe 'if there are no items' do
      it 'returns an empty array' do
        get '/api/v1/items'

        expect(response).to be_successful
        expect(response).to have_http_status(200)

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(0)
      end
    end
  end
end
