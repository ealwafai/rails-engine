FactoryBot.define do
  factory :invoice_item do
    invoice
    item
    quantity { 5 }
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
  end
end
