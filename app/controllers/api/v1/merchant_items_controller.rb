class Api::V1::MerchantItemsController < ApplicationController
  def index
    items = Merchant.find(params[:merchant_id]).items
      
    json_response(ItemSerializer.new(items))
  end
end
