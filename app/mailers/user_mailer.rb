class UserMailer < ApplicationMailer
  def commented_to_own_post(user_to, user_from, activity)
    @user_to = user_to
    @user_from = user_from
    @activity = activity
    mail to: @user_to.email,
      subject: "#{@user_from.username}さんがあなたの投稿にコメントしました"
  end

  def followed_me(user_to, user_from, activity)
    @user_to = user_to
    @user_from = user_from
    @activity = activity
    mail to: @user_to.email,
      subject: "#{@user_from.username}さんがあなたをフォローしました"
  end
  
  def liked_to_own_post(user_to, user_from, activity)
    @user_to = user_to
    @user_from = user_from
    @activity = activity
    mail to: @user_to.email,
      subject: "#{@user_from.username}さんがあなたの投稿にいいねしました"
  end
end
