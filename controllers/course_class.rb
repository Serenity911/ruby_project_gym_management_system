require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/course_class.rb' )
also_reload( '../models/*' )

get '/course_c/?' do
  @classes = CourseClass.all()
  erb(:"course_c/index")
end

# show all classes for a venue
get '/venues/:venue_id/course_c' do
  @venue_id = params[:venue_id]
  @classes = CourseClass.all_by_venue(@venue_id)
  @empty_classes = CourseClass.empty_classes(@venue_id)
  @full_classes = CourseClass.full_classes(@venue_id)
  erb(:"course_c/index_by_venue")
end

# create a new class
# form for new

get '/venues/:venue_id/course_c/new' do
  @venue_id = params['venue_id']
  erb(:"course_c/new")
end

# update the new

post '/venues/:venue_id/course_c' do
  course_class = CourseClass.new(params)
  course_class.save()
  redirect to("/venues/#{params[:venue_id]}")
end

# show all members signed in and add one from a filtered droplist
get '/venues/:venue_id/course_c/:course_id' do
  @class = CourseClass.find(params[:course_id])
  @members = Member.all_bookable(@class, "active", @class.membership_id)
  @members_signed_in = @class.members_list()

  erb(:"course_c/show")
end

# book a member to a class
post '/venues/:venue_id/course_c/:course_id/book' do
  CourseClass.find(params[:course_id]).book_member(Member.find(params['member_id']))
  redirect to("/venues/#{params[:venue_id]}/course_c/#{params[:course_id]}")
end

# cancel a booking of a member to a class
post '/venues/:venue_id/course_c/:course_id/cancel_booking/:member_id' do
  @class = CourseClass.find(params[:course_id])
  @class.cancel_booking(Member.find(params['member_id']))
  redirect to("/venues/#{params[:venue_id]}/course_c/#{params[:course_id]}")
end

# delete a class
get '/venues/:venue_id/course_c/:course_id/delete' do
  @class = CourseClass.find(params[:course_id])
  @members_count = @class.members_count()
  erb(:"course_c/delete")
end

# delete a class
post '/venues/:venue_id/course_c/:course_id/delete' do
  @class = CourseClass.find(params[:course_id])
  @members_count = @class.members_count()
  @class.destroy()
  redirect to("/venues/#{params[:venue_id]}")
end

# edit this class

get '/venues/:venue_id/course_c/:course_id/edit' do
  @venue_id = params['venue_id']
  @class = CourseClass.find(params[:course_id])
  erb(:"course_c/edit")
end

# update
post '/venues/:venue_id/course_c/:id/update' do
  course_class = CourseClass.new(params)
  course_class.update()
  redirect to("/venues/#{params['venue_id']}/course_c/#{params['id']}")
end
