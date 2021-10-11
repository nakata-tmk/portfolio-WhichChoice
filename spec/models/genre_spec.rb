# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Genreモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { genre.valid? }

    let(:genre) { build(:genre) }

    context 'nameカラム' do
      it '空欄でないこと' do
        genre.name = ''
        is_expected.to eq false
      end
      it '10文字以下であること: 10文字は〇' do
        genre.name = Faker::Lorem.characters(number: 10)
        is_expected.to eq true
      end
      it '10文字以下であること: 11文字は×' do
        genre.name = Faker::Lorem.characters(number: 11)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Questionモデルとの関係' do
      it '1:Nとなっている' do
        expect(Genre.reflect_on_association(:questions).macro).to eq :has_many
      end
    end
  end
end