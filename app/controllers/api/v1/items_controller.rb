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
    invoice_items = InvoiceItem.find_invoice_items(params[:id])
    invoice_ids = invoice_items.pluck(:invoice_id)
    invoice_items.delete_all
    render json: Item.delete(params[:id])
    Invoice.delete_empty_invoices(invoice_ids)
  end

  def update 
    if is_valid_merchant_id?
      return render status: 404
    end
    update_item(params[:id])
  end

  private
  
  def is_valid_merchant_id?
    params[:item][:merchant_id] && Merchant.find_by(id: merchant_id = params[:item][:merchant_id]) == nil
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def update_item(id)
    item = Item.update(id, item_params)
    render json: ItemSerializer.new(item)
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end