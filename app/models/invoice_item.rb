class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates :unit_price, presence: true, numericality: true
end
