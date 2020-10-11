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
      auto_login(@user)
      redirect_to @user, notice: "新規ユーザーを登録しました。"
    else
      flash.now[:denger] = "ユーザー登録に失敗しました"
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
      flash.now[:denger] = "ユーザー更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: 'ユーザーを削除しました'
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
