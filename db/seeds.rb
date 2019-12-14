require( "pry" )
require_relative( "../models/venue.rb" )
require_relative( "../models/member.rb" )
require_relative( "../models/course_class.rb" )
require_relative( "./sql_runner.rb" )

Venue.delete_all()
CourseClass.delete_all()
Member.delete_all()

venue1 = Venue.new({
  "name" => "New Martial Club",
  "address" => "100 Watson Cresent",
  "max_number_classes" => 2
})

venue1.save()

venue2 = Venue.new({
  "name" => "Combat Center",
  "address" => "100 Watson Cresent",
  "max_number_classes" => 2
})

venue2.save()

course_class1 = CourseClass.new({
  'name' => 'Kick defence',
  'max_capacity' => 20,
  'venue_id' => venue1.id,
  'membership_level' => "Silver"
  })

course_class1.save()

course_class2 = CourseClass.new({
  'name' => 'Punch defence',
  'max_capacity' => 26,
  'venue_id' => venue1.id,
  'membership_level' => "Gold"
  })

course_class2.save()


member1 = Member.new({
  'name' => 'Jenny',
  'status' => 'active',
  'membership' => 'Gold'
  })

member1.save()

member2 = Member.new({
  'name' => 'Paul',
  'status' => 'active',
  'membership' => 'Silver'
  })

member2.save()

binding.pry

nil
