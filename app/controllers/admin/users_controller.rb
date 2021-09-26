class Admin::UsersController < ApplicationController
  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      redirect_to admin_users_path, notice: '更新しました'
    else
      @user = user
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :sex, :age, :area, :image_id, :is_active)
    end
end
