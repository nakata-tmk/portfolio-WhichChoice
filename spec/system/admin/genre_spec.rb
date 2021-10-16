# frozen_string_literal: true

require 'rails_helper'

describe '管理者：Genreコントローラーのテスト' do
  let!(:admin) { create(:admin) }
  let!(:genre) { create(:genre) }
  before do
    visit new_admin_admin_session_path
    fill_in 'admin_admin[email]', with: admin.email
    fill_in 'admin_admin[password]', with: admin.password
    find('input[name="commit"]').click
  end

  describe '一覧画面のテスト' do
    before do
      visit admin_genres_path
    end
    context '表示の確認' do
      it '「ジャンル一覧」が表示されている' do
        expect(page).to have_content 'ジャンル一覧'
      end
      it '新規作成ボタンが表示されている' do
        expect(page).to have_button '新規作成'
      end
      it 'パスが"/admin/genres"である' do
        expect(current_path).to eq('/admin/genres')
      end
    end
    context '新規作成成功のテスト' do
      before do
        fill_in 'genre[name]', with: Faker::Lorem.characters(number: 5)
      end
      it '新しい投稿が正しく保存される' do
        expect { click_on '新規作成' }.to change{Genre.count}.by(1)
      end
      it 'リダイレクト先が、ジャンル一覧画面になっている' do
        click_on '新規作成'
        expect(current_path).to eq '/admin/genres'
      end
      it 'メッセージが表示される' do
        click_on '新規作成'
        expect(find('#notice', visible: false).text(:all)).to include '新規作成しました'
      end
    end
    context '新規作成失敗のテスト' do
      before do
        fill_in 'genre[name]', with: ''
      end
      it '新しい投稿が保存されない' do
        expect { click_on '新規作成' }.not_to change(Genre.all, :count)
      end
      it 'リダイレクト先が、ジャンル一覧画面になっている' do
        click_on '新規作成'
        expect(current_path).to eq '/admin/genres'
      end
      it 'メッセージが表示される' do
        click_on '新規作成'
        expect(find('#message', visible: false).text(:all)).to include '入力してください'
      end
    end
  end

  describe '編集のテスト' do
    before do
      visit edit_admin_genre_path(genre)
    end
    context '表示の確認' do
      it 'データが表示されている' do
        expect(page).to have_field 'genre[name]', with: genre.name
      end
      it '保存ボタンが表示される' do
        expect(page).to have_button '保存'
      end
    end
    context '更新成功のテスト' do
      before do
        @old_name = genre.name
        fill_in 'genre[name]', with: Faker::Lorem.characters(number: 5)
        click_on '変更を保存'
      end
      it 'nameが正しく更新される' do
        expect(genre.reload.name).not_to eq @old_name
      end
      it 'リダイレクト先が、ジャンル一覧画面になっている' do
        expect(current_path).to eq '/admin/genres'
      end
      it 'メッセージが表示される' do
        expect(find('#notice', visible: false).text(:all)).to include '更新しました'
      end
    end
    context '更新失敗のテスト' do
      before do
        fill_in 'genre[name]', with: ''
        click_on '変更を保存'
      end
      it 'リダイレクト先が、編集画面になっている' do
        expect(current_path).to eq admin_genre_path(genre)
      end
      it 'メッセージが表示される' do
        expect(find('#message', visible: false).text(:all)).to include '入力してください'
      end
    end
  end
end