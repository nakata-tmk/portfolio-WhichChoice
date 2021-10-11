# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '2文字以上であること: 1文字は×' do
        user.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以上であること: 2文字は〇' do
        user.name = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '15文字以下であること: 15文字は〇' do
        user.name = Faker::Lorem.characters(number: 15)
        is_expected.to eq true
      end
      it '15文字以下であること: 16文字は×' do
        user.name = Faker::Lorem.characters(number: 16)
        is_expected.to eq false
      end
      it '一意性があること' do
        user.name = other_user.name
        is_expected.to eq false
      end
    end

    context 'sexカラム' do
      it '空欄でないこと' do
        user.sex = ''
        is_expected.to eq false
      end
    end

    context 'ageカラム' do
      it '空欄でないこと' do
        user.age = ''
        is_expected.to eq false
      end
    end

    context 'areaカラム' do
      it '空欄でないこと' do
        user.area = ''
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Questionモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:questions).macro).to eq :has_many
      end
    end

    context 'Answerモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:answers).macro).to eq :has_many
      end
    end

    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
    end

    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
  end
end