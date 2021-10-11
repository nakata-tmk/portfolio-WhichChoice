# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Questionモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { question.valid? }

    let(:user) { create(:user) }
    let(:genre) { create(:genre) }
    let!(:question) { build(:question, user_id: user.id, genre_id: genre.id) }

    context 'object1カラム' do
      it '空欄でないこと' do
        question.object1 = ''
        is_expected.to eq false
      end
      it '15文字以下であること: 15文字は〇' do
        question.object1 = Faker::Lorem.characters(number: 15)
        is_expected.to eq true
      end
      it '15文字以下であること: 16文字は×' do
        question.object1 = Faker::Lorem.characters(number: 16)
        is_expected.to eq false
      end
    end

    context 'object2カラム' do
      it '空欄でないこと' do
        question.object2 = ''
        is_expected.to eq false
      end
      it '15文字以下であること: 15文字は〇' do
        question.object2 = Faker::Lorem.characters(number: 15)
        is_expected.to eq true
      end
      it '15文字以下であること: 16文字は×' do
        question.object2 = Faker::Lorem.characters(number: 16)
        is_expected.to eq false
      end
    end

    context 'bodyカラム' do
      it '空欄でないこと' do
        question.body = ''
        is_expected.to eq false
      end
      it '50文字以下であること: 50文字は〇' do
        question.body = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end
      it '50文字以下であること: 51文字は×' do
        question.body = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Question.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Genreモデルとの関係' do
      it 'N:1となっている' do
        expect(Question.reflect_on_association(:genre).macro).to eq :belongs_to
      end
    end

    context 'Answerモデルとの関係' do
      it '1:Nとなっている' do
        expect(Question.reflect_on_association(:answers).macro).to eq :has_many
      end
    end

    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Question.reflect_on_association(:comments).macro).to eq :has_many
      end
    end

    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(Question.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
  end
end