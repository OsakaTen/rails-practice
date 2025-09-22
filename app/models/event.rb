class Event < ApplicationRecord
  belongs_to :user

  # 入力チェック（これらの項目は必須）
  validates :title, :description, :event_date, :organizer_name, :target_departments, presence: true
  validates :public_token, presence: true, uniqueness: true

  # イベント作成時に公開トークンを自動生成
  before_validation :generate_public_token, on: :create

  # 便利なスコープ（検索用のメソッド）
  scope :upcoming, -> { where('event_date > ?', Time.current) }  # 未来のイベント
  scope :past, -> { where('event_date <= ?', Time.current) }     # 過去のイベント

  # URLでトークンを使用するための設定
  def to_param
    public_token
  end

  private

  # ランダムなトークンを生成するメソッド
  def generate_public_token
    self.public_token = SecureRandom.urlsafe_base64(12) if public_token.blank?
  end
end
