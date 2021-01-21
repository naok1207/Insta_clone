class Mypage::NotificationSettingsController < ApplicationController
  # 通知設定編集
  def edit
    @user = current_user
  end

  # 通知設定更新
  def update
    @user = User.find(current_user.id)
    if @user.update(notification_settings_params)
      redirect_to current_user
    else
      render :edit
    end
  end

  private

  def notification_settings_params
    params.require(:user).permit( 
      :notification_on_comment, 
      :notification_on_follow, 
      :notification_on_like
      )
  end
end
