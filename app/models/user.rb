class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_many :events, dependent: :destroy

  # devicenの設定を変えてこちらでは書かないようにしました

  validates :first_name, presence: true
  validates :last_name, presence: true

  # フルネームを返すメソッド ここから下はAiで書きました
  def full_name
    [last_name, first_name].compact.join(" ")
  end

  # 管理者かどうかをチェック
  def admin?
    role == 'admin'
  end

  # 一般ユーザーかどうかをチェック
  def regular_user?
    role == 'user' || role.nil?
  end
end