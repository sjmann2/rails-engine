class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update]
  def index
    if params[:merchant_id]
      items = Merchant.find(params[:merchant_id]).items
      
      json_response(ItemSerializer.new(items))
    else
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    render json: ItemSerializer.new(@item)
  end

  def create
    item = Item.create!(item_params)
    json_response(ItemSerializer.new(item), :created)
  end

  def destroy
    json_response(Item.delete(params[:id]))
  end

  def update 
    require 'pry' ; binding.pry
    ItemSerializer.new(@item.update(item_params))
    head :accepted
  end

  private
  
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end