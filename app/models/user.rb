class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { in: 2..15 }
  validates :sex, presence: true
  validates :age, presence: true
  validates :area, presence: true

  attachment :image

  enum sex: {
    man: 0,
    woman: 1
  }

  enum age: {
    teens: 0,
    twenties: 1,
    thirties: 2,
    forties: 3,
    fifties: 4,
    sixties: 5
  }

  enum area: {
    hokkaidou: 0,
    touhoku: 1,
    kantou: 2,
    cyuubu: 3,
    kansai: 4,
    cyuugoku: 5,
    shikoku: 6,
    kyuusyuu: 7
  }

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.name = "ゲスト"
      user.sex = 0
      user.age = 0
      user.area = 0
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def active_for_authentication?
    super && (self.is_active === true)
  end
end
