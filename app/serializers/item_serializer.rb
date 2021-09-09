class ItemSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :description, :unit_price, :merchant_id

  attributes :revenue, if: proc { |item| item.attributes['revenue'].present? }
end
