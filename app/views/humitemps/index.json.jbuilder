json.array!(@humitemps) do |humitemp|
  json.extract! humitemp, :id, :humidity, :temperature, :measured_at, :created_at, :box_id
  json.url humitemp_url(humitemp, format: :json)
end
