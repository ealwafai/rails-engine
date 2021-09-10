class RevenueSerializer
  def self.format_for_range(revenue)
    {
      data:
      {
        id: nil,
        type: 'revenue',
        attributes: {
          revenue: revenue
        }
      }
    }
  end

  def self.weekly_revenue(weeks)
    { data: weeks.map do |week|
              {
                id: nil,
                type: 'weekly_revenue',
                attributes: {
                  week: week.week.to_s,
                  revenue: week.revenue
                }
              }
            end }
  end
end
