#get all merchants
require 'rails_helper'

describe "Merchants API" do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    #at this point the response is a json string
    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    # now that we have a ruby object, we can make assertions about it
    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end
end