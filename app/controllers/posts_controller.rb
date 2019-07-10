class PostsController < ApplicationController
    before_action :require_login
    before_action :current_user
    def index
        if params.has_key?(:filter)
            @posts = filter(params)
        end
        if params.has_key?(:q)
            @posts = search(params)
        else
            @posts = Post.all.sort_by{ |post| post.likes.count}.reverse
        end
    end

    def new
        @post = Post.new
    end

    def create
        city_location_params(params)
        if params[:post][:user_id].to_i == current_user.id
            @post = Post.new(post_params)
            if @post.save
                redirect_to post_path(@post)
            else
                flash[:user_error] = "There was an error processing your request."
                @post = Post.new
                render :new
            end
        else
            flash[:user_error] = "There was an error processing your request."
            @post = Post.new
            render :new
        end
    end

    def edit
        @post = Post.find(params[:id])
    end

    def update
        city_location_params(params) 
        if params[:post][:user_id].to_i == current_user.id
            @post = Post.find(params[:id])
            params[:post][:avatar] = @post.avatar
            if @post.update(post_params)
                redirect_to post_path(@post)
            else
                flash[:user_error] = "There was an error processing your request."
                render :edit
            end
        else
            flash[:user_error] = "There was an error processing your request."
            @post = Post.find(params[:id])
            render :edit
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

    def city_location_params(params)
        city = params[:post][:city_id].downcase
        city_object = City.find_or_create_by(name: city)
        params[:post][:city_id] = city_object.id
        location = params[:post][:location_id].downcase
        location_object = Location.find_by(name: location)
        if location_object 
            params[:post][:location_id] = location_object.id
        else
            location_object = Location.create(name: location, city_id: city_object.id)
            params[:post][:location_id] = location_object.id
            params[:post][:city_id] = city_object.id
        end
        params
    end

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
        users = User.where("username ilike ?", "%#{query}%")
        users.each do |user|
            results_array << user.posts
        end
        results_array.flatten        
    end

    def require_login
        if !session[:user_id]
            redirect_to login_path
        end
    end

    def filter(params)
        filter_array = []
        filter = params[:filter]
        case filter
        when "newest"
            return Post.all.sort_by{ |post| post.created_at}
        when "liked"
            return Post.all.sort_by{ |post| post.likes.count}.reverse
        when "oldest"
            return Post.all.sort_by{ |post| post.created_at}.reverse
        end
    end
end
