class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:followed_id])
    UserMailer.followed_me(@user, current_user).deliver_later if current_user.follow(@user) && @user.notification_on_follow?
  end

  def destroy
    # Relationshipモデルよりidに対応するデータを取得し, followed_idによりuserを参照したものを取得
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
  end
end
