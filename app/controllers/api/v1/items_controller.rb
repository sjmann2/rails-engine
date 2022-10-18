class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: [:show]
  def index
    if params[:merchant_id]
      items = Merchant.find(params[:merchant_id]).items
      # items = Item.where(merchant_id: params[:merchant_id])
      
      json_response(ItemSerializer.new(items))
    else
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    render json: ItemSerializer.new(@item)
  end

  private
  
  def set_item
    @item = Item.find(params[:id])
  end
end