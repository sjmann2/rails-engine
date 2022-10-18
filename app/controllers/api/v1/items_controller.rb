class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    render json: ItemSerializer.new(items)
    # items = Item.find_by_merchant(params[:merchant_id])
    # render json: ItemSerializer.new(items)
    # json_response(ItemSerializer.new(items))
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end
end