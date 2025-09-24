# app/models/event.rb
class Event < ApplicationRecord
  belongs_to :user

  validates :title, :body, :event_date, :organizer_name, :target_department, presence: true

end
