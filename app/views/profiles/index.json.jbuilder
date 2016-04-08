json.array!(@profiles) do |profile|
  json.extract! profile, :id, :name, :email
  json.url profile_url(profile, format: :json)
end
