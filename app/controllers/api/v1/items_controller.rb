class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: [:show]
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
    invoice_items = InvoiceItem.where(item_id: params[:id])
    invoice_ids = invoice_items.pluck(:invoice_id)
    # I want to look at this invoice item, check it's invoice_id, check how many invoice items this id is on
    invoice_items.delete_all
    render json: Item.delete(params[:id])
    filtered_invoice_ids = Invoice.empty_invoices(invoice_ids)
    # require 'pry' ; binding.pry
    filtered_invoice_ids.each do |id|
      Invoice.find(id).delete
    end
  end

  def update 
    if params[:item][:merchant_id]
      if Merchant.find_by(id: merchant_id = params[:item][:merchant_id]) == nil
        render status: 404
      else
        item = Item.update(params[:id], item_params)
        render json: ItemSerializer.new(item)
      end
    else    
      item = Item.update(params[:id], item_params)
      render json: ItemSerializer.new(item)
    end
  end

  private
  
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end