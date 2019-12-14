require( "pry" )
require_relative( "../models/venue.rb" )
require_relative( "../models/member.rb" )
require_relative( "../models/course_class.rb" )
require_relative( "./sql_runner.rb" )

Venue.delete_all()

venue1 = Venue.new({
  "name" => "New Martial Club",
  "address" => "100 Watson Cresent",
  "max_number_classes" => "2"
})

venue1.save()

Venue.all()

course_class1 = CourseClass.new({
  'name' => 'Kick defence',
  'max_capacity' => 20,
  'venue_id' => venue1.id
  })

course_class1.save()

binding.pry
nil
