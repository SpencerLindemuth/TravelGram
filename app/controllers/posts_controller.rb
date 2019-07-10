class PostsController < ApplicationController
    before_action :require_login
    before_action :current_user
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
        city = params[:post][:city_id].downcase
        city_object = City.find_or_create_by(name: city)
        params[:post][:city_id] = city_object.id
        location = params[:post][:location_id].downcase
        location_object = Location.find_by(name: location)
        if location_object 
            params[:post][:location_id] = location_object.id
        else
            location_object = Location.create(name: location, city_id: city_object.id)
            params[:post][:city_id] = location_object.id
        end
        #byebug
        if params[:post][:user_id].to_i == current_user.id
            @post = Post.new(post_params)
            if @post.save
                redirect_to post_path(@post)
            else
                flash[:user_error] = "There was an error processing your request."
                render :new
            end
        else
            flash[:user_error] = "There was an error processing your request."
            @post = Post.new
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

end
