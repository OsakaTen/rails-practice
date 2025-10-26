class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_many :events, dependent: :destroy

  # validates :first_name, :last_name, :role, presence: true

  # enum role: { user: 0, admin: 1 }

  # def full_name
  #   [first_name, last_name].compact.join(" ")
  # end

  # バリデーション
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  # フルネームを返すメソッド ここから下はAiで書きました
  def full_name
    if first_name.present? && last_name.present?
      "#{last_name} #{first_name}"
    else
      email
    end
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