class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params.has_key?("ratings")
       @search_criteria = params["ratings"].keys
    end

    @movies = Movie.where :rating => @search_criteria
#    @movies = Movie.all
# temp to show checkbox
    @all_ratings = {'G'=>false, 'PG'=>false, 'PG-13'=>false, 'R'=>false}
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def sort
    if params[:sort_item] == "title" 
       @movies = Movie.all(:order => "title")
       @highlight = "title"
    else
       @movies = Movie.all(:order => "release_date")
       @highlight = "release_date"
    end
    render :action => "index"
  end
end
