class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "新規ユーザーを登録しました。"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'ユーザーを更新しました。'
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
