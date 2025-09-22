class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    # 1人のユーザーは複数のイベントを持てる
  has_many :events, dependent: :destroy

  # 入力チェック（バリデーション）
  validates :first_name, :last_name, presence: true
  validates :role, inclusion: { in: %w[admin manager member] }

  # フルネームを返すメソッド
  def full_name
    "#{first_name} #{last_name}"
  end

  # イベント管理権限があるかチェック
  def can_manage_events?
    %w[admin manager].include?(role)
  end

end
