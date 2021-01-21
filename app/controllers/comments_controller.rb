class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    # コメント通知メール
    UserMailer.commented_to_own_post(@comment.post.user, @comment.user, @comment).deliver_now if @comment.save && @comment.post.user.notification_on_comment? && @comment.post.user != current_user
  end

  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update(comment_update_params)
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body)
  end
end
