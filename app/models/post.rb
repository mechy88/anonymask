class Post < ApplicationRecord
  enum :status, { unseen: 0, seen: 1, resolved: 2 }

  validates :title, presence: true, length: { maximum: 300 }
  validates :content, presence: true, length: { maximum: 40000 }
  validates :status,  inclusion: { in: statuses.keys, message: "status is not valid" }

  belongs_to :user
  has_many :reactions
  has_many :comments
end
