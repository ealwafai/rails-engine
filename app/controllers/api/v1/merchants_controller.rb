class Api::V1::MerchantsController < ApplicationController

  def index
    if params[:page] && params[:per_page]
      merchants = Merchant.paginate(page: params[:page], per_page: params[:per_page])
    elsif params[:page].to_i >= 1
      merchants = Merchant.paginate(page: params[:page], per_page: 20)
    elsif params[:per_page]
      merchants = Merchant.paginate(page: 1, per_page: params[:per_page])
    else
      merchants = Merchant.paginate(page: 1, per_page: 20)
    end
    json_response(MerchantSerializer.new(merchants))
  end

  def show
    @merchant = Merchant.find(params[:id])
    json_response(MerchantSerializer.new(@merchant))
  end
end
