class Mypage::ActivitiesController < ApplicationController
  def index
    @activities = current_user.activities.order(created_at: :desc).page(params[:page]).per(10)
  end
end