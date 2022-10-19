class Api::V1::Items::SearchController < ApplicationController
  def find
    item = Item.find_one_item(params[:name])
    if item == nil
      render json: {data: {}}
    else
      json_response(ItemSerializer.new(item))
    end
  end
end