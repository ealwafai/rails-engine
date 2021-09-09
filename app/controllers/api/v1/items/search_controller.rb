class Api::V1::Items::SearchController < ApplicationController

  def find_all
    @items = search_items(params)
    return json_response('', :bad_request) unless valid_search?(params)

    json = ItemSerializer.new(@items)
    json_response(json)
  end

  private

  def search_items(params)
    if params[:name]
      @items = Item.search_by_name(params[:name])
    elsif params[:min_price] || params[:max_price]
      @items = Item.search_by_price({ min_price: params[:min_price], max_price: params[:max_price] })
    end
  end

  def valid_search?(params)
    params[:name].present? ^ (params[:min_price] || params[:max_price])
  end
end
