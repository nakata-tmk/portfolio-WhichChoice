# frozen_string_literal: true

require 'rails_helper'

describe 'Favoriteコントローラーのテスト' do
  let!(:user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:question) { create(:question, user_id: user.id, genre_id: genre.id) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    find('input[name="commit"]').click
  end

  context 'いいねをクリックした場合' do
    before do
      visit question_path(question)
    end
    it 'いいねが付く' do
      Favorite.create(user_id: user.id, question_id: question.id)
      expect(question.favorites.count).to eq 1
    end
    it 'いいねを解除する' do
      favorite = Favorite.create(user_id: user.id, question_id: question.id)
      favorite.destroy
      expect(question.favorites.count).to eq 0
    end
  end
end
