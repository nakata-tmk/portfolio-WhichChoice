class Question < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :object1, presence: true, length: { maximum: 15 }
  validates :object2, presence: true, length: { maximum: 15 }
  validates :body, presence: true, length: { maximum: 100 }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.sort(selection, genre_id)
    case selection
    when 'new'
      if genre_id.present?
        where(genre_id: genre_id).order(created_at: :DESC)
      else
        order(created_at: :DESC)
      end
    when 'old'
      if genre_id.present?
        where(genre_id: genre_id).order(created_at: :ASC)
      else
        order(created_at: :ASC)
      end
    when 'favorites'
      if genre_id.present?
        left_joins(:favorites).where(genre_id: genre_id).group(:id).order('count(favorites.question_id) desc')
      else
        left_joins(:favorites).group(:id).order('count(favorites.question_id) desc')
      end
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
