# frozen_string_literal: true

require 'rails_helper'

describe '管理者：Userコントローラーのテスト' do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  before do
    visit new_admin_admin_session_path
    fill_in 'admin_admin[email]', with: admin.email
    fill_in 'admin_admin[password]', with: admin.password
    find('input[name="commit"]').click
  end

  describe '一覧画面のテスト' do
    before do
      visit admin_users_path
    end
    context '表示の確認' do
      it '「会員一覧」が表示されている' do
        expect(page).to have_content '会員一覧'
      end
      it '会員詳細へのリンクが表示されている' do
        expect(page).to have_link user.name, href: admin_user_path(user)
      end
      it 'パスが"/admin/users"である' do
        expect(current_path).to eq('/admin/users')
      end
    end
  end

  describe '詳細画面のテスト' do
    before do
      visit admin_user_path(user)
    end
    context '表示の確認' do
      it '「会員詳細」が表示されている' do
        expect(page).to have_content '会員詳細'
      end
      it '編集ボタンが表示されている' do
        expect(page).to have_link '編集', href: edit_admin_user_path(user)
      end
      it 'パスが"/admin/user/:id"である' do
        expect(current_path).to eq('/admin/users/' + user.id.to_s)
      end
    end
  end

  describe '編集のテスト' do
    before do
      visit edit_admin_user_path(user)
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
      it 'user[is_active]が表示されている' do
        expect(find_field('user[is_active]', match: :first).value).to include user.is_active.to_s
      end
      it '編集ボタンが表示される' do
        expect(page).to have_button '編集'
      end
    end
    context '更新成功のテスト' do
      before do
        @old_name = user.name
        @old_email = user.email
        @old_image = user.image
        @old_sex = user.sex
        @old_age = user.age
        @old_area = user.area
        @old_is_active = user.is_active
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 5)
        fill_in 'user[email]', with: Faker::Internet.email
        attach_file 'user_image', "#{Rails.root}/spec/fixtures/images/sample.jpg"
        select '女性', from: 'user_sex'
        select '20代', from: 'user_age'
        select '東北', from: 'user_area'
        find('#user_is_active_false').click
        click_on '編集'
      end
      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @old_name
      end
      it 'emailが正しく更新される' do
        expect(user.reload.email).not_to eq @old_email
      end
      it 'imageが正しく更新される' do
        expect(user.reload.image).not_to eq @old_image
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
      it 'is_activeが正しく更新される' do
        expect(user.reload.email).not_to eq @old_is_active
      end
      it 'リダイレクト先が、詳細画面になっている' do
        expect(current_path).to eq admin_user_path(user)
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
        expect(current_path).to eq admin_user_path(user)
      end
      it 'メッセージが表示される' do
        expect(find('#message', visible: false).text(:all)).to include '入力してください'
      end
    end
  end
end