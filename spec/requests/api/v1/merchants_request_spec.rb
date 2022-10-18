require 'rails_helper'

describe "Merchants API" do
  describe "GET /merchants" do
    it 'returns merchants' do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      #at this point the response is a json string
      expect(response).to be_successful
      expect(response).to have_http_status(200)

      merchants = JSON.parse(response.body, symbolize_names: true)
      # now that we have a ruby object, we can make assertions about it
      expect(merchants[:data].count).to eq(3)

      merchants.each do |merchant|
        expect(merchant[1][0][:attributes]).to have_key(:name)
        expect(merchant[1][0][:attributes][:name]).to be_a(String)
      end
    end
  end

  describe "if there are no merchants" do
    it 'returns an empty array' do
      get '/api/v1/merchants'

      expect(response).to be_successful
      expect(response).to have_http_status(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(0)
    end
  end

  describe "GET /merchants/:id" do
    describe "when the record exits"
      it 'returns the merchant' do
        id = create(:merchant).id

        get "/api/v1/merchants/#{id}"

        expect(response).to be_successful
        expect(response).to have_http_status(200)
        
        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(merchant[:data]).to have_key(:id)
        expect(merchant[:data][:id]).to eq("#{id}")
        expect(merchant[:data][:attributes]).to have_key(:name)
        expect(merchant[:data][:attributes][:name]).to be_a(String)
      end
    end

  describe "when the record does not exist" do
    it 'returns a status code 404' do
      get "/api/v1/merchants/1"

      expect(response).to have_http_status(404)
    end

    it 'returns a not found message' do
      get "/api/v1/merchants/1"

      expect(response.body).to match(/Couldn't find Merchant/)
    end
  end

  describe 'GET /merchants/:id/items' do
    describe 'when the record exists' do
      it 'returns all items for a given merchant' do
        merchant = create(:merchant)
        items = create_list(:item, 3, merchant: merchant)

        get "/api/v1/merchants/#{merchant.id}/items"

        expect(response).to be_successful
        expect(response).to have_http_status(200)
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(3)
   
        expect(items[:data][0]).to have_key(:id)
        # expect(items[:data][0][:id]).to be_an(Integer)
        #should this be a string or should I be able to access it as an integer?
        expect(items[:data][0][:attributes]).to have_key(:name)
        expect(items[:data][0][:attributes][:name]).to be_a(String)
        expect(items[:data][0][:attributes]).to have_key(:description)
        expect(items[:data][0][:attributes][:description]).to be_a(String)
        expect(items[:data][0][:attributes]).to have_key(:unit_price)
        expect(items[:data][0][:attributes][:unit_price]).to be_a(Float)
      end
    end

    # describe 'when the record does not exist' do
    #   it 'returns a status code 404' do
    #     get "/api/v1/merchants/1/items"
        
    #     expect(response).to have_http_status(404)
    #   end

    #   it 'returns a not found message' do
    #     get "/api/v1/merchants/1/items"

    #     expect(response.body).to match(/Couldn't find Merchant/)
    #   end
    # end
  end
end