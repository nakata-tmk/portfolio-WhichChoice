# frozen_string_literal: true

require 'rails_helper'

describe 'Answerコントローラーのテスト' do
  let!(:user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:question) { create(:question, user_id: user.id, genre_id: genre.id) }
  let!(:answer) { create(:answer, user_id: user.id, question_id: question.id) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    find('input[name="commit"]').click
    visit question_path(question)
  end

  context '新規作成成功のテスト' do
    before do
      choose 'answer_answer_0'
    end
    it '新しい投稿が正しく保存される' do
      expect { click_on '投票' }.to change{question.answers.count}.by(1)
    end
    it 'リダイレクト先が、アンケート詳細画面になっている' do
      click_on '投票'
      expect(current_path).to eq question_path(question)
    end
    it 'メッセージが表示される' do
      click_on '投票'
      expect(find('#notice', visible: false).text(:all)).to include '投票しました'
    end
  end
  context '新規作成失敗のテスト' do
    before do
      find('input[name="commit"]', match: :first).click
    end
    it '新しい投稿が保存されない' do
      expect { click_on '投票' }.not_to change(question.answers, :count)
    end
    it 'リダイレクト先が、アンケート詳細画面になっている' do
      click_on '投票'
      expect(current_path).to eq question_path(question)
    end
    it 'メッセージが表示される' do
      click_on '投票'
      expect(find('#alert', visible: false).text(:all)).to include '投票項目を選択してください'
    end
  end
end