class Public::FavoritesController < ApplicationController
  def create
    question = Question.find(params[:question_id])
    favorite = current_user.favorites.new(question_id: question.id)
    favorite.save
    redirect_to question_path(question)
  end

  def destroy
    question = Question.find(params[:question_id])
    favorite = current_user.favorites.find_by(question_id: question.id)
    favorite.destroy
    redirect_to question_path(question)
  end
end
