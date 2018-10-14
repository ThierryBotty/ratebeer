class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    @best_beers = Beer.all.sort_by{ |b| b.average_rating }.reverse.first(3)
    @best_breweries = Brewery.all.sort_by{ |b| b.average_rating }.reverse.first(3)
    @best_styles = Style.all.sort_by{ |b| b.average_rating }.reverse.first(3)
    @most_active_users = User.all.sort_by{ |u| u.ratings.count() }.reverse.first(3)
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    # otetaan luotu reittaus muuttujaan
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if current_user.nil?
      redirect_to signin_path, notice: 'you should be signed in'
    elsif @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
    # talletetaan tehty reittaus sessioon
    # session[:last_rating] = "#{rating.beer.name} #{rating.score} points"
    # redirect_to ratings_path
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
