# frozen_string_literal: true

require 'rails_helper'

describe 'Commentコントローラーのテスト' do
  let!(:user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:question) { create(:question, user_id: user.id, genre_id: genre.id) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    find('input[name="commit"]').click
    visit question_path(question)
  end

  context '新規作成成功のテスト' do
    before do
      fill_in 'comment[body]', with: Faker::Lorem.characters(number: 20)
    end
    it '新しい投稿が正しく保存される' do
      expect { click_on 'コメントする' }.to change{question.comments.count}.by(1)
    end
    it 'リダイレクト先が、アンケート詳細画面になっている' do
      click_on 'コメントする'
      expect(current_path).to eq question_path(question)
    end
    it 'メッセージが表示される' do
      click_on 'コメントする'
      expect(find('#notice', visible: false).text(:all)).to include 'コメントしました'
    end
  end
  context '新規作成失敗のテスト' do
    before do
      fill_in 'comment[body]', with: ''
    end
    it '新しい投稿が保存されない' do
      expect { click_on 'コメントする' }.not_to change(question.comments, :count)
    end
    it 'リダイレクト先が、アンケート詳細画面になっている' do
      click_on 'コメントする'
      expect(current_path).to eq question_path(question)
    end
    it 'メッセージが表示される' do
      click_on 'コメントする'
      expect(find('#alert', visible: false).text(:all)).to include '入力してください'
    end
  end
  context '削除のテスト' do
    before do
      click_link '削除'
    end
    it '正しく削除される' do
      expect(Comment.where(id: question.id).count).to eq 0
    end
  end
end