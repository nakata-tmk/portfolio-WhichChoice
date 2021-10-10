class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(current_user.id)
    @questions = Question.where(user_id: current_user.id).page(params[:page])
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    user = User.find(current_user.id)
    if user.update(user_params)
      redirect_to users_path, notice: '更新しました'
    else
      @user = user
      render :edit
    end
  end

  def leave
  end

  def withdraw
    user = User.find(current_user.id)
    user.update(is_active: false)
    reset_session
    redirect_to root_path, notice: '退会しました'
  end

  before_action :check_guest, only: [:update, :withdraw]
  def check_guest
    if current_user.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザー情報の編集・削除はできません。'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :sex, :age, :area, :image)
    end
end
