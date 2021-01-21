class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    UserMailer.liked_to_own_post(@post.user, current_user, @post).deliver_later if current_user.like(@post) && @post.user.notification_on_like?
  end

  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
