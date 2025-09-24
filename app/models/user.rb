class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_many :events, dependent: :destroy

  # validates :first_name, :last_name, :role, presence: true

  enum role: { user: 0, admin: 1 }

  def full_name
    [first_name, last_name].compact.join(" ")
  end
end