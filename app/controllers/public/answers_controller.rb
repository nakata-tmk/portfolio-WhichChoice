class Public::AnswersController < ApplicationController
  before_action :check_guest, only: [:create]
  def check_guest
    if current_user.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーのため権限がありません'
    end
  end

  def create
    if params[:answer][:answer].present?
      answer = Answer.new(answer_params)
      answer.user_id = current_user.id
      answer.save
      redirect_to question_path(params[:answer][:question_id]), notice: '投票しました'
    else
      redirect_to question_path(params[:answer][:question_id]), alert: '投票項目を選択してください'
    end
  end

  private
    def answer_params
      params.require(:answer).permit(:user_id, :question_id, :answer)
    end
end
