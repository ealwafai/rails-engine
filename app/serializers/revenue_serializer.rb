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
end
