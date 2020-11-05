class Mypage::AccountsController < ApplicationController
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(account_params)
      redirect_to @user, notice: 'プロフィールを更新しました。'
    else
      flash.now[:denger] = 'プロフィール更新に失敗しました'
      render :edit
    end
  end

  private

  def account_params
    params.require(:user).permit(:avatar, :username)
  end
end
