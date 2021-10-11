# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Answerモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { answer.valid? }

    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:answer) { build(:answer, user_id: user.id, question_id: question.id) }

    context 'answerカラム' do
      it '空欄でないこと' do
        answer.answer = ''
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '1:Nとなっている' do
        expect(Answer.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Questionモデルとの関係' do
      it '1:Nとなっている' do
        expect(Answer.reflect_on_association(:question).macro).to eq :belongs_to
      end
    end
  end
end