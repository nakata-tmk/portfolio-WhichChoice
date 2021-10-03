class Public::CommentsController < ApplicationController
  before_action :check_guest, only: [:create, :destroy]
  def check_guest
    if current_user.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーのため権限がありません'
    end
  end

  def create
    question = Question.find(params[:question_id])
    comment = Comment.new(comment_params)
    comment.user_id = current_user.id
    comment.question_id = question.id
    if comment.save
      redirect_to request.referer, notice: 'コメントしました'
    else
      redirect_to request.referer, alert: 'コメントを入力してください'
    end
  end

  def destroy
    comment = Comment.find_by(id: params[:id])
    comment.destroy
    redirect_to request.referer
  end

  private
    def comment_params
      params.require(:comment).permit(:user_id, :question_id, :body)
    end
end
