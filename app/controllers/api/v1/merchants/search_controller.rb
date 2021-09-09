class Api::V1::Merchants::SearchController < ApplicationController

  def find
    @merchant = Merchant.find_by_name(params[:name])

    return json_response({ error: 'Bad request' }, :bad_request) unless params[:name].present?

    if @merchant.nil?
      json_response({ data: {} })
    else
      json_response(MerchantSerializer.new(@merchant))
    end
  end
end
