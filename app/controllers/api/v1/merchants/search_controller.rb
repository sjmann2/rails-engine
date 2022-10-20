class Api::V1::Merchants::SearchController < ApplicationController
  def find_all
    merchants = Merchant.search_by_name(params[:name])
    json_response(MerchantSerializer.new(merchants))
  end
end