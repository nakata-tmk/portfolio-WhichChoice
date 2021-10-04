class Question < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :object1, presence: true
  validates :object2, presence: true
  validates :body, presence: true

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.sort(selection)
    case selection
    when 'new'
      order(created_at: :DESC)
    when 'old'
      order(created_at: :ASC)
    when 'favorites'
      all.sort { |a, b| b.favorites.count <=> a.favorites.count }
    end
  end

  scope :sort_list, -> {
    {
      "並び替え" => "",
      "新着順" => "new",
      "古い順" => "old",
      "いいね順" => "favorites"
    }
  }
end
