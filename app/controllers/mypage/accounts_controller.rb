class Mypage::AccountsController < ApplicationController
  def edit
    @user = User.find(current_user.id)
  end

  def update
    # @user = current_user の場合validationエラーが起こった際に挙動がおかしくなってしまう
    @user = User.find(current_user.id)
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
