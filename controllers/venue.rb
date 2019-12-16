require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/venue.rb' )
also_reload( '../models/*' )

get '/venues/?' do
  @venues = Venue.all()
  erb(:"venues/index")
end

get '/venues/:id/?' do
  @venue = Venue.find(params[:id])
  erb(:"venues/show")
end
