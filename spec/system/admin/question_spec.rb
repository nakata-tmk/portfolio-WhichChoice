# frozen_string_literal: true

require 'rails_helper'

describe '管理者：Questionコントローラーのテスト' do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:question) { create(:question, user_id: user.id, genre_id: genre.id) }
  before do
    visit new_admin_admin_session_path
    fill_in 'admin_admin[email]', with: admin.email
    fill_in 'admin_admin[password]', with: admin.password
    find('input[name="commit"]').click
    visit admin_question_path(question)
  end

  describe '詳細画面のテスト' do
    context '表示の確認' do
      it '全体タブが表示されている' do
        expect(page).to have_link '全体'
      end
      it '性別別タブが表示されている' do
        expect(page).to have_link '性別別'
      end
      it '年齢別タブが表示されている' do
        expect(page).to have_link '年齢別'
      end
      it '地域別タブが表示されている' do
        expect(page).to have_link '地域別'
      end
      it '削除リンクが表示されている' do
        expect(page).to have_link '削除', href: admin_question_path(question)
      end
    end
    context '削除のテスト' do
      before do
        click_link '削除'
      end
      it '正しく削除される' do
        expect(Question.where(id: question.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/admin'
      end
    end
  end
end