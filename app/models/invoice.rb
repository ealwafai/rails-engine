class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant

  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def self.revenue_per_range(start_date, end_date)
    end_date = (Date.parse(end_date) + 1).to_s
    joins(:transactions, :invoice_items)
      .where(transactions: { result: 'success' }, invoices: { status: 'shipped' })
      .where('?::tsrange @> invoices.created_at', "[#{start_date}, #{end_date})")
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
