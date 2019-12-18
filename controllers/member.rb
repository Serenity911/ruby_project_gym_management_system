require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/member.rb' )
require_relative('../models/membership.rb')
also_reload( '../models/*' )

# show all members for a class

# show all members
get '/members/?' do
  @members = Member.all()
  erb(:"members/index")
end

# show all members / status
get '/members/filter/:status' do
  @status = params['status']
  @members = Member.all_by_status(@status)
  erb(:"members/index_status")
end

# create new member
# show form
get '/members/new' do
  @memberships = Membership.all()
  erb(:"/members/new")
end

# new member - post
post '/members' do
  member = Member.new(params)
  member.save()
  redirect to("members/")
end

# show member details
get '/members/:id' do
  @member = Member.find(params['id'])
  erb(:"members/show")
end

# edit a member
get '/members/:id/edit' do
  @memberships = Membership.all()
  @member = Member.find(params['id'])
  erb(:"members/edit")
end

# update
post '/members/:id' do
  Member.new(params).update()
  redirect to("/members/#{params['id']}")
end

# delete >> destroy
post '/members/:id/delete' do
  @member = Member.find(params['id'])
  @member.destroy()
  redirect to("members/")
end

# delete >> archive or delete
get '/members/:id/archive_or_delete' do
  @member = Member.find(params['id'])
  erb(:"members/archive_or_delete")
end

# delete >> archive
post '/members/:id/archive' do
  @member = Member.find(params['id'])
  @member.archive()
  redirect back
end

# reactivate

post '/members/:id/reactivate' do
  @member = Member.find(params['id'])
  @member.reactivate()
  redirect back
end
