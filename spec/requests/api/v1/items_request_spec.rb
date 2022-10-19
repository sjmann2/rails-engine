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

    describe 'GET /items/:id' do
      describe 'when the record exists' do
        it 'returns the item' do
          merchant = create(:merchant)
          item = create(:item, merchant: merchant)

          get "/api/v1/items/#{item.id}"

          expect(response).to be_successful
          expect(response).to have_http_status(200)

          item = JSON.parse(response.body, symbolize_names: true)

          expect(item[:data]).to have_key(:id)
          expect(item[:data][:id]).to be_a(String)
          expect(item[:data][:attributes]).to have_key(:name)
          expect(item[:data][:attributes][:name]).to be_a(String)
          expect(item[:data][:attributes]).to have_key(:description)
          expect(item[:data][:attributes][:description]).to be_a(String)
          expect(item[:data][:attributes]).to have_key(:unit_price)
          expect(item[:data][:attributes][:unit_price]).to be_a(Float)
        end
      end

      describe 'when the record does not exist' do
        it 'returns a status code 404' do
          get "/api/v1/items/1"

          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          get "/api/v1/items/1"
          
          expect(response.body).to match(/Couldn't find Item/)
        end
      end
    end
  end 

  describe 'create an item and delete that item' do
    before :each do
      merchant = create(:merchant)

      @item_params = ({
        name: "Coffee Mug",
        description: "Keeps things warm",
        unit_price: 19.99,
        merchant_id: merchant.id
      })
    end

    describe 'POST /api/v1/items' do
      it 'can create a new item' do
        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/items", headers: headers, params: JSON.generate(item: @item_params)

        created_item = Item.last

        expect(response).to be_successful
        expect(response).to have_http_status(201)

        expect(created_item.name).to eq(@item_params[:name])
        expect(created_item.description).to eq(@item_params[:description])
        expect(created_item.unit_price).to eq(@item_params[:unit_price])
        expect(created_item.merchant_id).to eq(@item_params[:merchant_id])
      end
    end

    describe 'DELETE /api/v1/item/:id' do
      it 'can destroy the new item' do
        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/items", headers: headers, params: JSON.generate(item: @item_params)

        created_item = Item.last

        expect{ delete "/api/v1/items/#{created_item.id}" }.to change(Item, :count).by(-1)
        expect(response).to be_successful
        expect{Item.find(created_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PATCH /api/v1/books/:id' do
    describe 'when the record exists' do
      it 'can update an existing item' do
        id = create(:item).id

        previous_name = Item.last.name
        item_params = {name: 'Insulated Coffee Mug'}
        headers = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
        item = Item.find_by(id: id)

        expect(response).to be_successful
        expect(response).to have_http_status(200)
        expect(item.name).to_not eq(previous_name)
        expect(item.name).to eq('Insulated Coffee Mug')
      end
    end

    describe 'when the record does not exist' do
      it 'returns a status code 404' do
        item_params = {name: 'Insulated Coffee Mug'}
        headers = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v1/items/1", headers: headers, params: JSON.generate({item: item_params})

        expect(response).to have_http_status(404)
      end
    end

    describe 'when a merchant does not exist' do
      it 'returns a status code 404' do
        id = create(:item).id

        item_params = {merchant_id: 10000}
        headers = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /api/v1/items/:id/merchant' do
    describe 'when the record exists' do
      it 'return the merchant associated with an item' do
        merchant = create(:merchant)
        items = create_list(:item, 4, merchant: merchant)
        item = items.first

        get "/api/v1/items/#{item.id}/merchant"

        expect(response).to be_successful
        expect(response).to have_http_status(200)

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(merchant.count).to eq(1)
        expect(merchant[:data][:attributes]).to have_key(:name)
        expect(merchant[:data][:attributes][:name]).to be_a(String)
      end

      describe 'when the record does not exist' do
        it 'returns a status code 404' do
          get "/api/v1/items/1/merchant"

          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          get "/api/v1/items/1"
          
          expect(response.body).to match(/Couldn't find Item/)
        end
      end
    end
  end

  describe 'GET /api/v1/items/find' do
    let!(:merchant) {create(:merchant)}
    let!(:item_1) { Item.create!(name: "Coffee Mug", description: "Keeps things warm", unit_price: 19.99, merchant_id: merchant.id)}
    let!(:item_2) { Item.create!(name: "Mr Coffee", description: "Brews coffee", unit_price: 29.99, merchant_id: merchant.id)}
    let!(:item_3) { Item.create!(name: "Mx Coffee", description: "Brews coffee again", unit_price: 65.00, merchant_id: merchant.id)}
    let!(:item_4) { Item.create!(name: "French Press", description: "Brews coffee also", unit_price: 25.00, merchant_id: merchant.id)}

    describe 'when the record exists' do
      it 'returns a single item which matches a search term' do
        get "/api/v1/items/find?name=Mug"
        
        expect(response).to be_successful
        expect(response).to have_http_status(200)

        item = JSON.parse(response.body, symbolize_names: true)
        expect(item[:data][:attributes][:name]).to eq("Coffee Mug")
      end

      it 'returns the first item alphabetically if a search returns more than one match' do
        get "/api/v1/items/find?name=coffee"
        
        expect(response).to be_successful
        expect(response).to have_http_status(200)

        item = JSON.parse(response.body, symbolize_names: true)
        expect(item[:data][:attributes][:name]).to eq("Coffee Mug")
      end

      it 'returns a single item which matches a minimum price search' do
        get "/api/v1/items/find?min_price=50"

        expect(response).to be_successful
        expect(response).to have_http_status(200)

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to eq("Mx Coffee")
      end

      xit 'returns a single item which matches a maximum price search' do
        get "/api/v1/items/find?max_price=150"
      end

      xit 'returns a single item which matches both a minimum and maximum price search' do
        get "/api/v1/items/find?max_price=150&min_price=50"
      end

      xit 'cannnot search both name and min price at the same time' do
        get "/api/v1/items/find?name=ring&min_price=50"
      end

      xit 'cannot search both name and max price at the same time' do
        get "/api/v1/items/find?name=ring&max_price=50"
      end

      xit 'cannot search both name, min price, and max price at the same time' do
        get "/api/v1/items/find?name=ring&min_price=50&max_price=250"
      end
    end

    describe 'when the record does not exist' do
      it 'returns an empty array' do
        get "/api/v1/items/find?name=beans"

        expect(response).to be_successful
        expect(response).to have_http_status(200)

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item).to have_key(:data)
        expect(item[:data]).to eq({})
      end
    end
  end
end
