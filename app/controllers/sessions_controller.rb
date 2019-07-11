class SessionsController < ApplicationController
  def new
    if session[:user_id]
      redirect_to posts_path
    end
  end

  def create
    user = User.find_by(username: params[:session][:username])
    # byebug
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to posts_path
    else
      flash[:danger] = "Incorrect Username or Password"
      redirect_to login_path
    end
  end

  def destroy
    session.clear
    redirect_to login_path
  end
end
