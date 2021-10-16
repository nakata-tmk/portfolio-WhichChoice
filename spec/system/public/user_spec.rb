# frozen_string_literal: true

require 'rails_helper'

describe 'Userコントローラーのテスト' do
  let!(:user) { create(:user) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    find('input[name="commit"]').click
  end

  describe '詳細画面のテスト' do
    context '表示の確認' do
      it '「マイページ」が表示されている' do
        expect(page).to have_content 'マイページ'
      end
      it '編集ボタンが表示されている' do
        expect(page).to have_link '編集', href: edit_users_path
      end
      it '退会ボタンが表示されている' do
        expect(page).to have_link '退会', href: leave_users_path
      end
      it 'パスが"/users"である' do
        expect(current_path).to eq('/users')
      end
    end
  end

  describe '編集のテスト' do
    before do
      visit edit_users_path(user)
    end
    context '表示の確認' do
      it 'user[name]が表示されている' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it 'user[email]が表示されている' do
        expect(page).to have_field 'user[email]', with: user.email
      end
      it 'user[sex]が表示されている' do
        expect(find_field('user[sex]').value).to eq user.sex
      end
      it 'user[age]が表示されている' do
        expect(find_field('user[age]').value).to eq user.age
      end
      it 'user[area]が表示されている' do
        expect(find_field('user[area]').value).to eq user.area
      end
      it '編集ボタンが表示される' do
        expect(page).to have_button '編集'
      end
    end
    context '更新成功のテスト' do
      before do
        @old_name = user.name
        @old_email = user.email
        @old_sex = user.sex
        @old_age = user.age
        @old_area = user.area
        @old_is_active = user.is_active
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 5)
        fill_in 'user[email]', with: Faker::Internet.email
        select '女性', from: 'user_sex'
        select '20代', from: 'user_age'
        select '東北', from: 'user_area'
        click_on '編集'
      end
      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @old_name
      end
      it 'nameが正しく更新される' do
        expect(user.reload.email).not_to eq @old_email
      end
      it 'sexが正しく更新される' do
        expect(user.reload.email).not_to eq @old_sex
      end
      it 'ageが正しく更新される' do
        expect(user.reload.email).not_to eq @old_age
      end
      it 'areaが正しく更新される' do
        expect(user.reload.email).not_to eq @old_area
      end
      it 'statusが正しく更新される' do
        expect(user.reload.email).not_to eq @old_is_active
      end
      it 'リダイレクト先が、詳細画面になっている' do
        expect(current_path).to eq users_path
      end
      it 'メッセージが表示される' do
        expect(find('#notice', visible: false).text(:all)).to include '更新しました'
      end
    end
    context '更新失敗のテスト' do
      before do
        fill_in 'user[name]', with: ''
        click_on '編集'
      end
      it 'リダイレクト先が、編集画面になっている' do
        expect(current_path).to eq users_path
      end
      it 'メッセージが表示される' do
        expect(find('#message', visible: false).text(:all)).to include '入力してください'
      end
    end
  end
  describe '退会のテスト' do
    context '表示の確認' do
      before do
        visit leave_users_path
      end
      it '本当に退会しますか？が表示される' do
        expect(page).to have_content '本当に退会しますか？'
      end
      it '退会しないボタンが表示されている' do
        expect(page).to have_link '退会しない', href: users_path
      end
      it '退会するボタンが表示されている' do
        expect(page).to have_link '退会する', href: withdraw_users_path
      end
      it 'パスが"/users/leave"である' do
        expect(current_path).to eq('/users/leave')
      end
    end
    context '退会処理のテスト' do
      before do
        visit leave_users_path
      end
      it '退会しないボタンをクリックする：マイページに遷移する' do
        click_link '退会しない'
        expect(current_path).to eq('/users')
      end
      it '退会するボタンをクリックする：トップページに遷移する' do
        click_link '退会する'
        expect(current_path).to eq('/')
      end
    end
    context '退会後はログインできないかのテスト' do
      before do
        visit leave_users_path
        click_link '退会する'
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        find('input[name="commit"]').click
      end
      it 'ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
      it 'メッセージが表示される' do
        expect(find('#alert', visible: false).text(:all)).to include '退会済みです'
      end
    end
  end
end