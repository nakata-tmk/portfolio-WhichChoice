# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it '新規登録リンクが表示される: 左上から6番目のリンクが「新規登録」である' do
        sign_up_link = find_all('a')[6].native.inner_text
        expect(sign_up_link).to match(/会員登録する/i)
      end
      it '新規登録リンクの内容が正しい' do
        expect(page).to have_link '会員登録する', href: new_user_registration_path
      end
      it 'ログインリンクが表示される: 左上から7番目のリンクが「アンケート一覧」である' do
        log_in_link = find_all('a')[7].native.inner_text
        expect(log_in_link).to match(/アンケート一覧/i)
      end
      it 'ログインリンクの内容が正しい' do
        expect(page).to have_link 'アンケート一覧', href: questions_path
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit about_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/about'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end
    context '表示内容の確認' do
      it 'Aboutリンクが表示される: 左上から1番目のリンクが「About」である' do
        about_link = find_all('a')[1].native.inner_text
        expect(about_link).to match(/about/i)
      end
      it 'アンケートリンクが表示される: 左上から2番目のリンクが「アンケート」である' do
        questions_link = find_all('a')[2].native.inner_text
        expect(questions_link).to match(/アンケート/i)
      end
      it '新規登録リンクが表示される: 左上から3番目のリンクが「登録」である' do
        signup_link = find_all('a')[3].native.inner_text
        expect(signup_link).to match(/登録/i)
      end
      it 'ログインリンクが表示される: 左上から4番目のリンクが「ログイン」である' do
        login_link = find_all('a')[4].native.inner_text
        expect(login_link).to match(/ログイン/i)
      end
      it 'ゲストログインリンクが表示される: 左上から5番目のリンクが「ゲスト」である' do
        guest_link = find_all('a')[5].native.inner_text
        expect(guest_link).to match(/ゲスト/i)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'Aboutを押すと、アバウト画面に遷移する' do
        about_link = find_all('a')[1].native.inner_text
        about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link about_link
        is_expected.to eq '/about'
      end
      it 'アンケートを押すと、アンケート一覧画面に遷移する' do
        questions_link = find_all('a')[2].native.inner_text
        questions_link = questions_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link questions_link
        is_expected.to eq '/questions'
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[3].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[4].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link
        is_expected.to eq '/users/sign_in'
      end
      it 'ゲストを押すと、ゲストログイン後トップ画面に遷移する' do
        guest_link = find_all('a')[5].native.inner_text
        guest_link = guest_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link guest_link
        is_expected.to eq '/'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「新規登録」と表示される' do
        expect(page).to have_content '新規登録'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'sexフォームが表示される' do
        expect(page).to have_field 'user[sex]'
      end
      it 'ageフォームが表示される' do
        expect(page).to have_field 'user[age]'
      end
      it 'areaフォームが表示される' do
        expect(page).to have_field 'user[area]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        select '男性', from: 'user_sex'
        select '10代未満', from: 'user_age'
        select '北海道', from: 'user_area'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end
      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザのマイページになっている' do
        click_button '新規登録'
        expect(current_path).to eq '/users'
      end
    end
  end

  describe 'ユーザログイン' do
    let!(:user) { create(:user) }
    before do
      visit new_user_session_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        find('input[name="commit"]').click
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザのマイページになっている' do
        expect(current_path).to eq '/users'
      end
    end
    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        find('input[name="commit"]').click
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let!(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      find('input[name="commit"]').click
    end

    context 'ヘッダーの表示を確認' do
      it 'アンケートリンクが表示される: 左上から1番目のリンクが「アンケート」である' do
        questions_link = find_all('a')[1].native.inner_text
        expect(questions_link).to match(/アンケート/i)
      end
      it 'マイページリンクが表示される: 左上から2番目のリンクが「マイページ」である' do
        users_link = find_all('a')[2].native.inner_text
        expect(users_link).to match(/マイページ/i)
      end
      it 'ログアウトリンクが表示される: 左上から3番目のリンクが「ログアウト」である' do
        logout_link = find_all('a')[3].native.inner_text
        expect(logout_link).to match(/ログアウト/i)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let!(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      find('input[name="commit"]').click
      logout_link = find_all('a')[3].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/about'
      end
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end

  describe 'ログインしていない場合のアクセス権限のテスト' do
    context 'ログイン画面へリダイレクトする' do
      it 'マイページ画面' do
        visit users_path
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end
end