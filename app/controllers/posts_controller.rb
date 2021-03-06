class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show search]

  def index
    @posts = if current_user
               current_user.feed.order(created_at: :desc).page(params[:page])
             else
               Post.all.order(created_at: :desc).page(params[:page])
             end
    @users = User.recent(5)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to @post, notice: '新規投稿を作成しました.'
    else
      render :new
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: '投稿を編集しました.'
    else
      render :edit
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def search
    @posts = @search_form.search.includes(:user).page(params[:page])
    # binding pry
  end

  private

  def post_params
    params.require(:post).permit(:body, images: [])
  end
end
