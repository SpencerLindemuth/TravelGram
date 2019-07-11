class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])
    # byebug
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to posts_path
    else
      flash[:danger] = 'Invalid login info, please try to login again or create a new account'
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to login_path
  end
end
