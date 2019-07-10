class LikesController < ApplicationController
  before_action :require_login
  before_action :current_user
  before_action :find_post
  before_action :find_like, only: [:destroy]

  def create
    # byebug
    if already_liked?
      flash[:notice] = "You can't like more than once"
    else 
      @post.likes.create(user_id: current_user.id)
      redirect_to post_path(@post)
    end
  end

  def destroy
    if !(already_liked?)
      flash[:notice] = "Cannot unlike"
    else
      @like.destroy
    end
      redirect_to post_path(@post)
  end

  private

  def already_liked?
    Like.where(user_id: current_user.id, post_id:
    params[:post_id]).exists?
  end

  def find_post
    @post = Post.find(params[:post_id])
  end

  def find_like
    @like = @post.likes.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:post_id, :user_id)
  end

  def require_login
    if !session[:user_id]
      redirect_to login_path
    end
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

end
