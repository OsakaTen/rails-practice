# app/models/event.rb
class Event < ApplicationRecord
  belongs_to :user

  validates :title, :description, :event_date, :organizer_name, :target_departments, presence: true

end
