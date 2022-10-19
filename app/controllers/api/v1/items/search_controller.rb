class Api::V1::Items::SearchController < ApplicationController
  def find   
    if params[:min_price] && params[:max_price]
      search_min_max_price(params[min_price], params[:max_price])
    elsif params[:min_price]
      search_min_price(params[:min_price])
    elsif params[:max_price]
      search_max_price(params[:max_price])
    else
      search_name(params[:name])
    end
  end

  private

  def search_name(params)
    item = Item.item_by_name(params)

    json_formatter(item)
  end

  def search_min_price(params)
    item = Item.min_price(params)

    json_formatter(item)
  end

  def search_min_max_price
    item = Item.min_and_max_price

    json_formatter(item)
  end
  
  def json_formatter(item)
    if item == nil
      render json: {data: {}}
    else
      json_response(ItemSerializer.new(item))
    end
  end
end