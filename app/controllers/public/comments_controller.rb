class Public::CommentsController < ApplicationController
  before_action :check_guest, only: [:create, :update, :destroy]
  def check_guest
    if current_user.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーのため権限がありません'
    end
  end

  def create
    comment = Comment.new(comment_params_create)
    if comment.save
      redirect_to request.referer, notice: 'コメントしました'
    else
      redirect_to request.referer, alert: 'コメントを入力してください'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    comment = Comment.find(params[:id])
    if comment.update(comment_params_update)
      redirect_to question_path(comment.question_id), notice: 'コメントを編集しました'
    else
      @comment = comment
      render :edit
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to request.referer
  end

  private
    def comment_params_create
      params.permit(:user_id, :question_id, :body)
    end

    def comment_params_update
      params.require(:comment).permit(:user_id, :question_id, :body)
    end
end
