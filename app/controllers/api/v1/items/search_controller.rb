class Api::V1::Items::SearchController < ApplicationController
  def find 
    if min_or_max_price_and_name_present? || negative_prices? || price_invalid?
      render_error
    elsif min_and_max_present?
      search_min_max_price(params[:min_price], params[:max_price])
    elsif params[:min_price]
      search_min_price(params[:min_price])
    elsif params[:max_price]
      search_max_price(params[:max_price])
    elsif params[:name]
      search_name(params[:name])
    end
  end

  private

  def price_invalid?
    !((params[:min_price] || params[:max_price]) || params[:name]).present? || (min_and_max_present? && min_greater_than_max?)
  end

  def search_name(params)
    item = Item.item_by_name(params)

    json_formatter(item)
  end

  def search_min_price(params)
    item = Item.min_price(params)

    json_formatter(item)
  end

  def search_max_price(params)
    item = Item.max_price(params)

    json_formatter(item)
  end

  def min_or_max_price_and_name_present?
    (params[:min_price] && params[:name]).present? || (params[:max_price] && params[:name]).present?
  end

  def negative_prices?
    (params[:min_price] || params[:max_price]).to_i < 0
  end

  def min_and_max_present?
    (params[:min_price] && params[:max_price]).present?
  end

  def min_greater_than_max?
    params[:min_price].to_i > params[:max_price].to_i
  end

  def search_min_max_price(min_price, max_price)
    item = Item.min_and_max_price(min_price, max_price)

    json_formatter(item)
  end
  
  def json_formatter(item)
    if item == nil
      render json: {data: {}}
    else
      json_response(ItemSerializer.new(item))
    end
  end

  def render_error
    render :json => {error: "invalid search query"}, :status => 400
  end
end