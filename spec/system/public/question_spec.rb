# frozen_string_literal: true

require 'rails_helper'

describe 'Questionコントローラーのテスト' do
  let!(:user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:question) { create(:question, user_id: user.id, genre_id: genre.id) }
  let!(:user_2) { create(:user) }
  let!(:question_2) { create(:question, user_id: user_2.id, genre_id: genre.id) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    find('input[name="commit"]').click
  end

  describe 'トップ画面のテスト' do
    before do
      visit questions_path
    end
    context '表示の確認' do
      it '「アンケート一覧」が表示されている' do
        expect(page).to have_content 'アンケート一覧'
      end
      it 'アンケート詳細へのリンクが表示されている' do
        expect(page).to have_link href: question_path(question)
      end
      it 'パスが"/questions"である' do
        expect(current_path).to eq('/questions')
      end
    end
  end
  describe '検索機能のテスト' do
    before do
      visit questions_path
    end
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
  describe '新規投稿画面のテスト' do
    context '新規作成成功のテスト' do
      before do
        visit new_question_path
        fill_in 'question[object1]', with: Faker::Lorem.characters(number: 5)
        fill_in 'question[object2]', with: Faker::Lorem.characters(number: 5)
        select genre.name, from: 'question_genre_id'
        fill_in 'question[body]', with: Faker::Lorem.characters(number: 20)
      end
      it '新しい投稿が正しく保存される' do
        expect { click_on '投稿' }.to change{Question.count}.by(1)
      end
      it 'リダイレクト先が、アンケート一覧になっている' do
        click_on '投稿'
        expect(current_path).to eq questions_path
      end
      it 'メッセージが表示される' do
        click_on '投稿'
        expect(find('#notice', visible: false).text(:all)).to include '新規作成しました'
      end
    end
    context '新規作成失敗のテスト' do
      before do
        visit new_question_path
        fill_in 'question[object1]', with: ''
      end
      it '新しい投稿が保存されない' do
        expect { click_on '投稿' }.not_to change(Question.all, :count)
      end
      it 'リダイレクト先が、アンケート詳細画面になっている' do
        click_on '投稿'
        expect(current_path).to eq questions_path
      end
      it 'メッセージが表示される' do
        click_on '投稿'
        expect(find('#message', visible: false).text(:all)).to include '入力してください'
      end
    end
  end
  describe '詳細画面のテスト' do
    context '自分のアンケート詳細画面：表示の確認' do
      before do
        visit question_path(question)
      end
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
      it '編集リンクが表示されている' do
        expect(page).to have_link '編集', href: edit_question_path(question)
      end
      it '削除リンクが表示されている' do
        expect(page).to have_link '削除', href: question_path(question)
      end
    end
    context '他人のアンケート詳細画面：表示の確認' do
      before do
        visit question_path(question_2)
      end
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
      it '編集リンクが表示されない' do
        expect(page).not_to have_link '', href: edit_question_path(question_2)
      end
      it '削除リンクが表示されない' do
        expect(page).not_to have_link '', href: question_path(question_2)
      end
    end
  end
  describe '編集のテスト' do
    before do
      visit edit_question_path(question)
    end
    context '表示の確認' do
      it 'question[object1]が表示されている' do
        expect(page).to have_field 'question[object1]', with: question.object1
      end
      it 'question[object2]が表示されている' do
        expect(page).to have_field 'question[object2]', with: question.object2
      end
      it 'question[body]が表示されている' do
        expect(find_field('question[body]').value).to eq question.body
      end
      it '編集ボタンが表示される' do
        expect(page).to have_button '編集'
      end
    end
    context '更新成功のテスト' do
      before do
        @old_object1 = question.object1
        @old_object2 = question.object2
        @old_body = question.body
        fill_in 'question[object1]', with: Faker::Lorem.characters(number: 5)
        fill_in 'question[object2]', with: Faker::Lorem.characters(number: 5)
        fill_in 'question[body]', with: Faker::Lorem.characters(number: 15)
        click_on '編集'
      end
      it 'object1が正しく更新される' do
        expect(user.reload.name).not_to eq @old_object1
      end
      it 'object2が正しく更新される' do
        expect(user.reload.email).not_to eq @old_object2
      end
      it 'bodyが正しく更新される' do
        expect(user.reload.email).not_to eq @old_body
      end
      it 'リダイレクト先が、詳細画面になっている' do
        expect(current_path).to eq question_path(question)
      end
      it 'メッセージが表示される' do
        expect(find('#notice', visible: false).text(:all)).to include '更新しました'
      end
    end
    context '更新失敗のテスト' do
      before do
        fill_in 'question[object1]', with: ''
        click_on '編集'
      end
      it 'リダイレクト先が、編集画面になっている' do
        expect(current_path).to eq question_path(question)
      end
      it 'メッセージが表示される' do
        expect(find('#message', visible: false).text(:all)).to include '入力してください'
      end
    end
  end
  describe '削除のテスト' do
    before do
      visit question_path(question)
      page.all("a")[6].click
    end
    it '正しく削除される' do
      expect(Question.where(user_id: user.id).count).to eq 0
    end
    it 'リダイレクト先が、投稿一覧画面になっている' do
      expect(current_path).to eq '/questions'
    end
  end
end