# require 'pg'
# PG.connect(ENV['DATABASE_URL'] || 'postgres://localhost/gym')

require './app'
run Sinatra::Application
