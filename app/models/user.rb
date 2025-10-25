class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_many :events, dependent: :destroy

 # メール形式チェック
 #形式のチェックが入っていなかったので、。 user@example のような不完全なメールでも「有効」になっていました。そこで形式を統一するために修正した。
#  形式はAIで書いてもらいました
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

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