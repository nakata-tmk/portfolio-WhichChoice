class Genre < ApplicationRecord
  has_many :questions, dependent: :destroy

  validates :name, presence: true, length: { maximum: 10 }
end
