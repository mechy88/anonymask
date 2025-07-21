class Comment < ApplicationRecord
  validates :content, presence: true
  validates :content, length: { maximum: 10000 }

  belongs_to :user
  belongs_to :post
end
