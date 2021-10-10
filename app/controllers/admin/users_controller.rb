class Admin::UsersController < ApplicationController
  before_action :authenticate_admin_admin!

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
      redirect_to admin_user_path(user), notice: '更新しました'
    else
      @user = user
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :sex, :age, :area, :image, :is_active)
    end
end
