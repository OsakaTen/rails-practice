# app/models/event.rb
class Event < ApplicationRecord
  belongs_to :user
  
  # バリデーション
  validates :title, presence: true, length: { maximum: 200 }
  validates :event_date, presence: true
  validates :organizer_name, presence: true
  validates :description, allow_blank: true, length: { maximum: 5000 }
  validates :target_departments, presence: true

    # スコープ ここら下はAIで書きました
  scope :upcoming, -> { where('event_date >= ?', Date.today).order(event_date: :asc) }
  scope :past, -> { where('event_date < ?', Date.today).order(event_date: :desc) }
  scope :recent, -> { order(created_at: :desc) }

  # # コールバック
  # before_create :generate_public_token

  # イベントが過去のものかチェック
  def past?
    event_date < Date.today
  end

  # イベントが今日かチェック
  def today?
    event_date == Date.today
  end

  # イベントが未来のものかチェック
  def upcoming?
    event_date > Date.today
  end

  # 作成者の名前を取得
  def creator_name
    user&.full_name || user&.email || "不明"
  end

  private

  # # 公開用トークンを生成
  # def generate_public_token
  #   self.public_token = SecureRandom.urlsafe_base64(32)
  # end
end
