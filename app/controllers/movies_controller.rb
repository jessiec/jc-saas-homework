class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = {'G'=>false, 'PG'=>false, 'PG-13'=>false, 'R'=>false}
    if params.has_key?("ratings")
       @search_criteria = params["ratings"].keys
       @search_criteria.each { | value | @all_ratings[value] = true }
    end

    @movies = Movie.where :rating => @search_criteria
    session[:ratings_selection] = @search_criteria
#    @movies = Movie.all
# temp to show checkbox
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
    @all_ratings = {'G'=>false, 'PG'=>false, 'PG-13'=>false, 'R'=>false}
    if  session.has_key?(:ratings_selection)
        @search_criteria = session[:ratings_selection]
        @choices = {:rating=>@search_criteria}
        @search_criteria.each { | value | @all_ratings[value] = true }
    else
        @choices = :all
    end

    @movies = Movie.where(@choices).order(params[:sort_item])
    @highlight = params[:sort_item]

    render :action => "index"
  end
end
