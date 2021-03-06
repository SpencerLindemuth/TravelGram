class UsersController < ApplicationController
  before_action :user_params, only: [:create, :update]
  before_action :require_login
  before_action :current_user
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to posts_path
    else
      if params[:user][:password].empty? || params[:user][:password_confirmation].empty?
        flash[:danger] = "Password can't be blank."
      elsif params[:user][:password] != params[:user][:password_confirmation]
        flash[:danger] = "Passwords do not match."
      else
        flash[:danger] = "Your account has already been signed up, please log in with your existing account."
      end
      redirect_to new_user_path
    end
  end

  # def travelgram 
  # end

  # def authenticate
  #   @user = User.find_by(username: params[:user][:username], password: params[:user][:password])
  #   if User.find_by(username: params[:user][:username], password: params[:user][:password])
  #     redirect_to posts_path
  #   else
  #     flash[:new_user_message] = "No user information, please try log in again or create a new account"
  #     redirect_to "/"
  #   end
  # end

  def show 
    @user = User.find(params[:id])
    @posts = @user.posts.reverse
    @likes = @user.posts.map{ |post| post.likes}.flatten.count
    @post_count = @user.posts.count
    @location_count = @user.posts.map{ |post| post.location}.uniq.count
    @city_count = @user.posts.map{ |post| post.location.city}.uniq.count
  end

  def edit
    @user = User.find(params[:id])   
  end

  def update
    @user = User.find(params[:id])
    if User.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.delete
    redirect_to posts_path   
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :bio, :home_city, :password_confirmation)
  end

  def require_login
    if !session[:user_id]
      redirect_to login_path
    end
  end


end
