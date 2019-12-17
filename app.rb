require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative('controllers/course_class')
require_relative('controllers/member')
require_relative('controllers/venue')
require('pry')

get '/' do
  erb( :index )
end
