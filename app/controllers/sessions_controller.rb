class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
    else
      flash[:danger] = 'Invalid login info, please try to login again or create'
      render 'new'
    end
  end

  def destroy
    if session[:username].nil?
      redirect_to login_path
    else
      session.delete :username
      redirect_to login_path
    end
  end
end
