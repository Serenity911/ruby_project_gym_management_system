require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/membership.rb' )
require_relative('../models/membership.rb')
also_reload( '../models/*' )

# show all memberships

get '/memberships/?' do
	@memberships = Membership.all()
	erb(:"memberships/index")
end

# create new membership
# show form
get '/memberships/new' do
  @memberships = Membership.all()
  erb(:"/memberships/new")
end

# new membership - post
post '/memberships' do
  membership = Membership.new(params)
  membership.save()
  redirect to("memberships/")
end

# show membership details
get '/memberships/:id' do
  @membership = Membership.find(params['id'])
	@course_classes = @membership.get_courseclass()
  erb(:"memberships/show")
end

# edit a membership
get '/memberships/:id/edit' do
  @memberships = Membership.all()
  @membership = Membership.find(params['id'])
  erb(:"memberships/edit")
end

# update
post '/memberships/:id' do
  Membership.new(params).update()
  redirect to("/memberships/#{params['id']}")
end

# delete or deactivate
get '/memberships/:id/delete_deactivate' do
	@memberships = Membership.all()
	@membership = Membership.find(params['id'])
	erb(:"memberships/delete_deactivate")
end


# delete >> destroy
post '/memberships/:id/delete' do
  @membership = Membership.find(params['id'])
  @membership.destroy()
  redirect to("memberships/")
end


# deactivate
post '/memberships/:id/deactivate' do
  @membership = Membership.find(params['id'])
  @membership.deactivate()
	redirect to("/memberships/#{params['id']}")
end

# reactivate

post '/memberships/:id/reactivate' do
  @membership = Membership.find(params['id'])
  @membership.reactivate()
	redirect to("/memberships/#{params['id']}")
end

# show deactivated
get '/memberships/filter/deactivated' do
	@memberships = Membership.all()
	erb(:"memberships/index_deactivated")
end
