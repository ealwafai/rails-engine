class Api::V1::Revenue::MerchantsController < ApplicationController
  def show
    merchant = Merchant.find(params[:id])
    @merchant_revenue = merchant.total_revenue
    json_response(MerchantRevenueSerializer.new(@merchant_revenue))
  end
end
