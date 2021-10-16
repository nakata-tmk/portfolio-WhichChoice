# frozen_string_literal: true

require 'rails_helper'

describe '管理者：Homeコントローラーのテスト' do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:question) { create(:question, user_id: user.id, genre_id: genre.id) }
  before do
    visit new_admin_admin_session_path
    fill_in 'admin_admin[email]', with: admin.email
    fill_in 'admin_admin[password]', with: admin.password
    find('input[name="commit"]').click
  end

  describe 'トップ画面のテスト' do
    context '表示の確認' do
      it '「アンケート一覧」が表示されている' do
        expect(page).to have_content 'アンケート一覧'
      end
      it '会員詳細へのリンクが表示されている' do
        expect(page).to have_link user.name, href: admin_user_path(user)
      end
      it 'アンケート詳細へのリンクが表示されている' do
        expect(page).to have_link href: admin_question_path(question)
      end
      it 'パスが"/admin"である' do
        expect(current_path).to eq('/admin')
      end
    end
  end
  describe '検索機能のテスト' do
    context '表示の確認' do
      it '「キーワード検索」が表示されている' do
        expect(page).to have_content 'キーワード検索'
      end
      it 'キーワード検索フォームが表示されている' do
        expect(page).to have_field 'keyword'
      end
      it '「ジャンル一覧」が表示されている' do
        expect(page).to have_content 'ジャンル一覧'
      end
    end
    context 'キーワード検索する' do
      it '検索結果が表示' do
        fill_in 'keyword', with: 'あいうえお'
        find('input[name="commit"]').click
        expect(page).to have_content '検索結果'
      end
    end
    context 'ジャンル検索する' do
      it '検索結果が表示' do
        click_link genre.name
        expect(page).to have_content genre.name + '一覧'
      end
    end
    context 'ソートのテスト' do
      it 'ソートフォームが表示されている' do
        expect(page).to have_field 'sort'
      end
      it 'ソートリストが表示されている' do
        expect(page).to have_select('sort', options: ['並び替え', '新着順', '古い順', 'いいね順'])
      end
    end
  end
end