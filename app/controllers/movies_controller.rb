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
    if !session['ratings']
      session['ratings'] = {'G' =>1, 'PG' =>1, 'PG-13' =>1, 'R'=>1}
    end
    @all_ratings = ['G', 'PG','PG-13','R']
    if !params['ratings']
      params['ratings'] = session['ratings']
      redirect_to movies_path(:ratings =>session['ratings'], :sort => params[:sort])
    else
      session['ratings'] = params['ratings']
    end
    
    if params['sort'] == 'movies'
      @sort = :title
      @movies= Movie.where(rating: params['ratings'].keys).order(:title)
    elsif params['sort'] == 'release_date'
      @sort = :release_date
      @movies = Movie.where(rating: params['ratings'].keys).order(:release_date)
    else
     @movies = Movie.where(rating: params['ratings'].keys)
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
