json.extract! event, :id, :title, :description, :event_date, :organizer_name, :target_departments, :user_id, :public_token, :created_at, :updated_at
json.url event_url(event, format: :json)
