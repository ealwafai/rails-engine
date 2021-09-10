class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    params[:quantity] = 10 if params[:quantity].nil?
    return json_response({ error: 'Bad request' }, :bad_request) unless valid_quantity?(params[:quantity].to_i)

    @items = Item.order_by_revenue(params[:quantity])
    json_response(ItemSerializer.new(@items))
  end

  private

  def valid_quantity?(quantity)
    quantity.is_a?(Integer) && quantity >= 1
  end
end
