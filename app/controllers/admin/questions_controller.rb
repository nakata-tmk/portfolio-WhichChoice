class Admin::QuestionsController < ApplicationController
  def show
    @question = Question.find(params[:id])
  end

  def destroy
    question = Question.find(params[:id])
    question.destroy
    redirect_to admin_top_path
  end
end
