class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update]
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(@item)
  end

  def create
    item = Item.create!(item_params)
    json_response(ItemSerializer.new(item), :created)
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  def update 
    item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(item)

    # item = Item.update(params[:id], item_params)

    # if item.merchant_id == nil
    #   render status: 404
    # else
    #   render json: ItemSerializer.new(item)
    # end
  end

  private
  
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end