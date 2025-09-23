# app/models/event.rb
class Event < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :event_date, presence: true

  before_create :set_public_token

  private

  def set_public_token
    self.public_token = SecureRandom.hex(10) # 公開用URLのトークン
  end
end
