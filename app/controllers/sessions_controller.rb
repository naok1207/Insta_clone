class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
  end

  def create
    @user = login(session_params[:email], session_params[:password])
    if @user
      redirect_back_or_to @user
    else
      render :new
    end
  end

  def destroy
    logout
    redirect_to login_path
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
