class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    case params[:sort]
    when 'title'
      # sorts movie title alphabetically
      @movies = Movie.order('title ASC')
      @title_hilite = 'hilite'
    when 'release'
      # Sorts release date from latest
      @movies = Movie.order('release_date ASC')
      @release_hilite = 'hilite'
    case params[:ratings]
    when 'rating'
      # Displays movie on selected rating
      @movies = Movie.where(rating: params[:ratings].keys)
    end
    else
     params[:ratings] ? @movies = Movie.where(rating: params[:ratings].keys):
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

end
