class Question < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :answers0, ->{where answer: 0},class_name: :Answer
  has_many :answers1, ->{where answer: 1},class_name: :Answer

  has_many :answers0_man, ->{ joins(:user).where(answer: 0).where(users: { sex: 'man'}) }, class_name: :Answer
  has_many :answers1_man, ->{ joins(:user).where(answer: 1).where(users: { sex: 'man'}) }, class_name: :Answer
  has_many :answers0_woman, ->{ joins(:user).where(answer: 0).where(users: { sex: 'woman'}) }, class_name: :Answer
  has_many :answers1_woman, ->{ joins(:user).where(answer: 1).where(users: { sex: 'woman'}) }, class_name: :Answer

  has_many :answers0_teens, ->{ joins(:user).where(answer: 0).where(users: { age: 'teens'}) }, class_name: :Answer
  has_many :answers1_teens, ->{ joins(:user).where(answer: 1).where(users: { age: 'teens'}) }, class_name: :Answer
  has_many :answers0_twenties, ->{ joins(:user).where(answer: 0).where(users: { age: 'twenties'}) }, class_name: :Answer
  has_many :answers1_twenties, ->{ joins(:user).where(answer: 1).where(users: { age: 'twenties'}) }, class_name: :Answer
  has_many :answers0_thirties, ->{ joins(:user).where(answer: 0).where(users: { age: 'thirties'}) }, class_name: :Answer
  has_many :answers1_thirties, ->{ joins(:user).where(answer: 1).where(users: { age: 'thirties'}) }, class_name: :Answer
  has_many :answers0_forties, ->{ joins(:user).where(answer: 0).where(users: { age: 'forties'}) }, class_name: :Answer
  has_many :answers1_forties, ->{ joins(:user).where(answer: 1).where(users: { age: 'forties'}) }, class_name: :Answer
  has_many :answers0_fifties, ->{ joins(:user).where(answer: 0).where(users: { age: 'fifties'}) }, class_name: :Answer
  has_many :answers1_fifties, ->{ joins(:user).where(answer: 1).where(users: { age: 'fifties'}) }, class_name: :Answer
  has_many :answers0_sixties, ->{ joins(:user).where(answer: 0).where(users: { age: 'sixties'}) }, class_name: :Answer
  has_many :answers1_sixties, ->{ joins(:user).where(answer: 1).where(users: { age: 'sixties'}) }, class_name: :Answer

  has_many :answers0_hokkaidou, ->{ joins(:user).where(answer: 0).where(users: { area: 'hokkaidou'}) }, class_name: :Answer
  has_many :answers1_hokkaidou, ->{ joins(:user).where(answer: 1).where(users: { area: 'hokkaidou'}) }, class_name: :Answer
  has_many :answers0_touhoku, ->{ joins(:user).where(answer: 0).where(users: { area: 'touhoku'}) }, class_name: :Answer
  has_many :answers1_touhoku, ->{ joins(:user).where(answer: 1).where(users: { area: 'touhoku'}) }, class_name: :Answer
  has_many :answers0_kantou, ->{ joins(:user).where(answer: 0).where(users: { area: 'kantou'}) }, class_name: :Answer
  has_many :answers1_kantou, ->{ joins(:user).where(answer: 1).where(users: { area: 'kantou'}) }, class_name: :Answer
  has_many :answers0_cyuubu, ->{ joins(:user).where(answer: 0).where(users: { area: 'cyuubu'}) }, class_name: :Answer
  has_many :answers1_cyuubu, ->{ joins(:user).where(answer: 1).where(users: { area: 'cyuubu'}) }, class_name: :Answer
  has_many :answers0_kansai, ->{ joins(:user).where(answer: 0).where(users: { area: 'kansai'}) }, class_name: :Answer
  has_many :answers1_kansai, ->{ joins(:user).where(answer: 1).where(users: { area: 'kansai'}) }, class_name: :Answer
  has_many :answers0_cyuugoku, ->{ joins(:user).where(answer: 0).where(users: { area: 'cyuugoku'}) }, class_name: :Answer
  has_many :answers1_cyuugoku, ->{ joins(:user).where(answer: 1).where(users: { area: 'cyuugoku'}) }, class_name: :Answer
  has_many :answers0_shikoku, ->{ joins(:user).where(answer: 0).where(users: { area: 'shikoku'}) }, class_name: :Answer
  has_many :answers1_shikoku, ->{ joins(:user).where(answer: 1).where(users: { area: 'shikoku'}) }, class_name: :Answer
  has_many :answers0_kyuusyuu, ->{ joins(:user).where(answer: 0).where(users: { area: 'kyuusyuu'}) }, class_name: :Answer
  has_many :answers1_kyuusyuu, ->{ joins(:user).where(answer: 1).where(users: { area: 'kyuusyuu'}) }, class_name: :Answer

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
