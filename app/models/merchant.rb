class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.find_by_name(query)
    find_by_sql(['select * from merchants where name ilike ? order by lower(name) asc limit 1;', "%#{query}%"]).first
  end

  def total_revenue
    Merchant
      .joins(items: { invoices: :transactions })
      .select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .where(transactions: { result: 'success' }, invoices: { status: 'shipped' })
      .where(merchants: { id: id })
      .group('merchants.id').first
  end
end
