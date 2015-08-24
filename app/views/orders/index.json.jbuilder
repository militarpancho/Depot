json.array!(@orders) do |order|
  json.extract! order, :id, :name, :address, :email, :pay_type, :ship_date
  json.url order_url(order, format: :json)
end
