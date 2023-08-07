class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  def reset_token
    loop do
      token = rand.to_s[2..5]
      break token unless User.where(reset_password_token: token).first
    end
  end

  # User Association
  has_one_attached :image
  has_many :reviews,dependent: :destroy 
  has_one :subscription, dependent: :destroy

  # User Validation
  validates :username, uniqueness: true, presence: true
	validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
