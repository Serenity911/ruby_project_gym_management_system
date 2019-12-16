require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/course_class.rb' )
also_reload( '../models/*' )

get '/course_c/?' do
  @classes = CourseClass.all()
  erb(:"course_c/index")
end

get '/venues/:venue_id/course_c' do
  # @members = Member.all()
  @classes = CourseClass.all_by_venue(params[:venue_id])
  @empty_classes = CourseClass.empty_classes(params[:venue_id])
  @full_classes = CourseClass.full_classes(params[:venue_id])
  erb(:"course_c/index_by_venue")
end

get '/venues/:venue_id/course_c/:course_id' do
  @class = CourseClass.find(params[:course_id])
  # @members = Member.all()
  @members = Member.all_bookable(@class, "active", @class.membership_level)
  @members_signed_in = CourseClass.find(params[:course_id]).members_list()
  erb(:"course_c/show")
end

# book a member to a class
post '/venues/:venue_id/course_c/:course_id' do
  CourseClass.find(params[:course_id]).book_member(Member.find(params['member_id']))
  redirect to("/venues/#{params[:venue_id]}/course_c/#{params[:course_id]}")
end
