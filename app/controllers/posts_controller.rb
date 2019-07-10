class PostsController < ApplicationController
    before_action :require_login
    def index
        if params.has_key?(:q)
            @posts = search(params)
        else
            @posts = Post.all
        end
    end

    def new
        @post = Post.new
    end

    def create
        #byebug
        @post = Post.new(post_params)
        if @post.save
            redirect_to post_path(@post)
        else
            render :new
        end
    end

    def show
        @post = Post.find(params[:id])
    end

    def destroy
        @post = Post.find(params[:id])
        @post.destroy
        redirect_to posts_path
    end



    private

    def post_params
        params.require(:post).permit(:caption, :image_url, :user_id, :location_id, :avatar)
    end

    def search(params)
        results_array = []
        query = params[:q]
        results_array << Post.where("caption ilike ?", "%#{query}%")
        locations = Location.where("name ilike ?", "%#{query}%")
        locations.each do |location|
            results_array << Post.all.select{|post| post.location == location}
        end
        cities = City.where("name ilike ?", "%#{query}%")
        cities.each do |city|
            results_array << Post.all.select{|post| post.location.city == city}
        end
        results_array.flatten        
    end

    def require_login
        if !session[:user_id]
            redirect_to login_path
        end
    end

end
