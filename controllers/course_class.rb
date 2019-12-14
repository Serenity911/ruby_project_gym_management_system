require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/course_class.rb' )
also_reload( '../models/*' )

get '/venues/:id/course_c' do
  @classes = CourseClass.all_by_venue(params[:id])
  erb(:"course_c/index")
end

# get '/venues/:id/dashboard' do
#   @venue = Venue.find(params[:id])
#   erb(:"venues/show")
# end
