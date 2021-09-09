class Api::V1::RevenueController < ApplicationController
  def show
    return json_response({ error: 'Bad request' }, :bad_request) unless valid_range?(params)

    @revenue = Invoice.revenue_per_range(params[:start], params[:end])
    json_response(RevenueSerializer.format_for_range(@revenue))
  end

  private

  def valid_range?(params)
    start_date = valid_date?(params[:start])
    end_date = valid_date?(params[:end])
    start_date && end_date && start_date < end_date
  end

  def valid_date?(date)
    date.present? && Date.strptime(date, '%Y-%m-%d')
  rescue Date::Error
    false
  end
end
