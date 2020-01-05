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
  "max_number_classes" => 4
})

venue1.save()

venue2 = Venue.new({
  "name" => "Combat Center",
  "address" => "100 Watson Cresent",
  "max_number_classes" => 10
})

venue2.save()

venue3 = Venue.new({
  "name" => "Average Joe",
  "address" => "100 Watson Cresent",
  "max_number_classes" => 2
})

venue3.save()

venue4 = Venue.new({
  "name" => "Globo Gym",
  "address" => "1 Main Road",
  "max_number_classes" => 200
})

venue4.save()

membership1 = Membership.new({
  'name' => "Gold",
  'price' => 20
  })

membership1.save()

membership2 = Membership.new({
  'name' => "Silver",
  'price' => 10
  })

membership2.save()

course_class1 = CourseClass.new({
  'name' => 'Kick defence',
  'course_date' => '2019-12-17',
  'max_capacity' => 20,
  'venue_id' => venue1.id,
  'membership_id' => membership2.id
  })

course_class1.save()

course_class2 = CourseClass.new({
  'name' => 'Punch defence',
  'course_date' => '2019-12-18',
  'max_capacity' => 26,
  'venue_id' => venue1.id,
  'membership_id' => membership1.id
  })

course_class2.save()

course_class3 = CourseClass.new({
  'name' => 'Awareness Seminar',
  'course_date' => '2019-12-19',
  'max_capacity' => 3,
  'venue_id' => venue1.id,
  'membership_id' => membership1.id
  })

course_class3.save()

course_class4 = CourseClass.new({
  'name' => 'MMA Workshop',
  'course_date' => '2019-12-21',
  'max_capacity' => 3,
  'venue_id' => venue1.id,
  'membership_id' => membership1.id
  })

course_class4.save()

course_class5 = CourseClass.new({
  'name' => 'Dodgeball class',
  'course_date' => '2019-12-17',
  'max_capacity' => 2,
  'venue_id' => venue3.id,
  'membership_id' => membership2.id
  })

course_class5.save()

member1 = Member.new({
  'name' => 'Jenny',
  'status' => 'active'
  })

member1.save()

member1.add_membership(membership1)

member2 = Member.new({
  'name' => 'Paul',
  'status' => 'active'
  })

member2.save()
member2.add_membership(membership2)

member3 = Member.new({
  'name' => 'John',
  'status' => 'active'
  })

member3.save()
member3.add_membership(membership1)

member4 = Member.new({
  'name' => 'Karolina',
  'status' => 'active'
  })

member4.save()
member4.add_membership(membership1)


member5 = Member.new({
  'name' => 'Bill',
  'status' => 'active'
  })

member5.save()
member5.add_membership(membership1)

member6 = Member.new({
  'name' => 'Stuart',
  'status' => 'archived'
  })

member6.save()
member6.add_membership(membership2)


member7 = Member.new({
  'name' => 'Frodo',
  'status' => 'paused'
  })

member7.save()
member7.add_membership(membership2)


member8 = Member.new({
  'name' => 'Sam',
  'status' => 'paused'
  })

member8.save()
member8.add_membership(membership2)


member9 = Member.new({
  'name' => 'Julie',
  'status' => 'archived'
  })

member9.save()
member9.add_membership(membership2)


member10 = Member.new({
  'name' => 'Smeagol',
  'status' => 'archived'
  })

member10.save()
member10.add_membership(membership2)

# binding.pry
#
# nil
