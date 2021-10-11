# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Commentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { comment.valid? }

    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:comment) { build(:comment, user_id: user.id, question_id: question.id) }

    context 'bodyカラム' do
      it '空欄でないこと' do
        comment.body = ''
        is_expected.to eq false
      end
      it '30文字以下であること: 30文字は〇' do
        comment.body = Faker::Lorem.characters(number: 30)
        is_expected.to eq true
      end
      it '30文字以下であること: 30文字は×' do
        comment.body = Faker::Lorem.characters(number: 31)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '1:Nとなっている' do
        expect(Comment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Questionモデルとの関係' do
      it '1:Nとなっている' do
        expect(Comment.reflect_on_association(:question).macro).to eq :belongs_to
      end
    end
  end
end