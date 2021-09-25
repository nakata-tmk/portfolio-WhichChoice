class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :answer, presence: true

  enum answer: {
    object1: 0,
    object2: 1
  }
end
