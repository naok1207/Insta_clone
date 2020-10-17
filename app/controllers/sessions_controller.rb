class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
  end

  def create
    @user = login(session_params[:email], session_params[:password])
    if @user
      redirect_back_or_to @user, notice: 'ログインしました。'
    else
      flash.now[:denger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout
    redirect_to login_path, notice: 'ログアウトしました。'
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
