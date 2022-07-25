json.extract! store, :id, :name, :password_digest, :address, :joinDate, :created_at, :updated_at
json.url store_url(store, format: :json)
