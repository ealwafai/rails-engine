class Api::V1::Items::MerchantsController < ApplicationController
  def index
    @item = Item.find(params[:id])
    @merchant = Merchant.find(@item.merchant_id)
    json_response(MerchantSerializer.new(@merchant))
  end
end
