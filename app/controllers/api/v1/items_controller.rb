class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    render json: ItemSerializer.new(items)
    # items = Item.find_by_merchant(params[:merchant_id])
    # render json: ItemSerializer.new(items)
    # json_response(ItemSerializer.new(items))
  end
end