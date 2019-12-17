require( "pry" )
require_relative( "../models/venue.rb" )
require_relative( "../models/member.rb" )
require_relative( "../models/course_class.rb" )
require_relative( "../models/membership.rb" )

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

membership1 = Membership.new({
  'name' => "Gold",
  'price' => 20
  })

membership1.save()

membership2 = Membership.new({
  'name' => "Silver",
  'price' => 20
  })

membership2.save()

course_class1 = CourseClass.new({
  'name' => 'Kick defence',
  'course_date' => '2019-12-19',
  'max_capacity' => 20,
  'venue_id' => venue1.id,
  'membership_id' => membership2.id
  })

course_class1.save()

course_class2 = CourseClass.new({
  'name' => 'Punch defence',
  'course_date' => '2019-12-20',
  'max_capacity' => 26,
  'venue_id' => venue1.id,
  'membership_id' => membership1.id
  })

course_class2.save()

course_class3 = CourseClass.new({
  'name' => 'Awareness Seminar',
  'course_date' => '2019-12-21',
  'max_capacity' => 3,
  'venue_id' => venue1.id,
  'membership_id' => membership1.id
  })

course_class3.save()

member1 = Member.new({
  'name' => 'Jenny',
  'status' => 'active',
  'membership_id' => membership1.id
  })

member1.save()

member2 = Member.new({
  'name' => 'Paul',
  'status' => 'active',
  'membership_id' => membership2.id
  })

member2.save()

binding.pry

nil
