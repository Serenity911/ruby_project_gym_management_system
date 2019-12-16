require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/venue.rb' )
also_reload( '../models/*' )

get '/venues/?' do
  @venues = Venue.all()
  erb(:"venues/index")
end


# create a new venue
# form for new

get '/venues/new' do
  # binding.pry
  erb(:"venues/new")
end

get '/venues/:id/?' do
  @venue = Venue.find(params[:id])
  erb(:"venues/show")
end


# update the new

post '/venues/' do
  venue = Venue.new(params)
  venue.save()
  redirect to("/venues/#{venue.id}")
end

# delete this venue

get '/venues/:id/delete' do
  @venue = Venue.find(params[:id])
  erb(:"venues/delete")
end

# delete a class
post '/venues/:id/delete' do
  @venue = Venue.find(params[:id])
  @venue.destroy()
  redirect to("/venues/?")
end
