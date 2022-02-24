class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      Movie.order("title")
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