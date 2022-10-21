class Api::V1::Merchants::SearchController < ApplicationController
  def find_all
    if name_invalid?
      render_error
    else
      merchants = Merchant.search_by_name(params[:name])
      json_response(MerchantSerializer.new(merchants))
    end
  end

  private
  def name_invalid?
    !params[:name].present? || params[:name].empty?
  end

  def render_error
    render :json => {error: "invalid search query"}, :status => 400
  end
end