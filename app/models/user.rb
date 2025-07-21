class User < ApplicationRecord
  has_secure_password

  enum :role, { user: 0, admin: 1 }

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :username, :email, :role, presence: true
  validates :username, :email, uniqueness: true

  validates :username, length: { maximum: 20 }
  validates :email, length: { maximum: 320 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: roles.keys, message: "You do not have a valid role" }

  has_many :posts, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :comments, dependent: :destroy

  def display_name(current_user = nil)
    return "You" if current_user && self == current_user
    return username if current_user&.admin?

    "👤 Anonymous"
  end
end
