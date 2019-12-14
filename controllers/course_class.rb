require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/course_class.rb' )
also_reload( '../models/*' )

get '/venues/:venue_id/course_c' do
  @classes = CourseClass.all_by_venue(params[:venue_id])
  erb(:"course_c/index")
end

get '/venues/:venue_id/course_c/:course_id' do
  @class = CourseClass.find(params[:course_id])
  erb(:"course_c/show")
end
