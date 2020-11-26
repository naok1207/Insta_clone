class ActivitiesController < ApplicationController
  def read
    # 通知を検索
    activity = current_user.activities.find(params[:id])
    # 既読済でない場合既読をつける
    activity.read! if activity.unread?
    # 通知が示すデータへアクセスする
    redirect_to activity.redirect_path
  end
end
