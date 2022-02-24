class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      
      @all_ratings = Movie.select("DISTINCT(rating)").order("rating").map{|entry| entry.rating}
      @checked_dict = {}
      @all_ratings.each do |rating| @checked_dict[rating]=true end
      # if params[:prev_checked_dict]
      #   p "Prev_checked"
      #   p params[:prev_checked_dict]
      #   # @checked_dict = params[:prev_checked_dict]
      #   @checked_dict = Hash[params[:prev_checked_dict].map { |k,v| [k, ActiveRecord::Type::Boolean.new.type_cast_from_user(v) ]}]
      # end
      
      if params["ratings"]
        @checked_array = @all_ratings.map{|rating| params["ratings"][rating]}
        @all_ratings.each do |rating|
          p params["ratings"][rating]
          if params["ratings"][rating]
            @checked_dict[rating] = true
          else
            @checked_dict[rating] = false
          end
        end
        
      end
      
      if params[:sort]
        if params[:sort] == "title"
          @css_title = "bg-warning"
          @css_title_hilite = "hilite"
          @css_release_date = ""
          @css_release_date_hilite = ""
        elsif params[:sort] == "release_date"
          @css_title = ""
          @css_title_hilite = ""
          @css_release_date = "bg-warning"
          @css_release_date_hilite = "hilite"
        else
          @css_title = ""
          @css_release_date = ""
        end
          
        @movies = Movie.order(params[:sort]).all
      else
        @movies = Movie.all
      end
      
      
      
      p @checked_dict
      
      @final_rating_array = []
      
      @all_ratings.each do |rating|
        if @checked_dict[rating]
          @final_rating_array.push(rating)
        end
      end
      p @final_rating_array
      
      @movies = @movies.select{|entry| @final_rating_array.include?(entry.rating)}
      
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
      params.require(:cssclass)
    end
end