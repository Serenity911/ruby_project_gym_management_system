require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/member.rb' )
also_reload( '../models/*' )

# show all members for a class

# show all members
get '/members/?' do
  @members = Member.all()
  erb(:"members/index")
end


# create new member
# show form
get '/members/new' do
  erb(:"/members/new")
end

# new member - post
post '/members' do
  member = Member.new(params)
  member.save
  redirect to("members/")
end

# show member details
get '/members/:id' do
  @member = Member.find(params['id'])
  erb(:"members/show")
end

# edit a member
get '/members/:id/edit' do
  @member = Member.find(params['id'])
  erb(:"members/edit")
end

# update
post '/members/:id' do
  Member.new(params).update
  redirect to("/members/#{params['id']}")
end
# delete >> archive
