json.array!(@boxes) do |box|
  json.extract! box, :id, :access_token, :updated_at, :created_at, :user_id, :open
  json.url box_url(box, format: :json)
end
