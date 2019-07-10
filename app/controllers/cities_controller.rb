class CitiesController < ApplicationController
    def show
        @city = City.find(params[:id])
        @city_locations = @city.locations
        @city_posts = @city_locations.map{ |location| location.posts}.flatten

    end
end
