class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true, length: { maximum: 30 }
end
