class MoviesController < ApplicationController
  def index
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @movies = Movie.where("actors::text ILIKE ?", search_term).page(params[:page]).per(10)
    else
      @movies = Movie.left_joins(:reviews)
                     .group(:id)
                     .order('AVG(reviews.stars) DESC')
                     .page(params[:page])
                     .per(10)
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end
end
