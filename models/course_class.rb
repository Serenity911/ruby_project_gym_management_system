require_relative( "../db/sql_runner" )


class CourseClass

  attr_reader :id, :name, :max_capacity, :venue_id

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @max_capacity = options['max_capacity'].to_i
    @venue_id = options['venue_id'].to_i
    @membership_level = options['membership_level']
    # add date
    # add days of week
    # add instructors
  end


  # create a course_class

  def save()
    sql = "INSERT INTO course_classes
    (name, max_capacity, venue_id, membership_level)
    VALUES
    ($1, $2, $3, $4)
    RETURNING id;"
    values = [@name, @max_capacity, @venue_id, @membership_level]
    @id = SqlRunner.run( sql, values ).first['id'].to_i
  end

  # delete all the course_classes

  def self.delete_all()
    sql = "DELETE FROM course_classes;"
    SqlRunner.run( sql )
  end

  # show all the course_classes

  def self.all()
    sql = "SELECT * FROM course_classes;"
    result = SqlRunner.run( sql )
    return result.map{|courseclass| CourseClass.new( courseclass )}
  end

  # delete one course_class

  def destroy()
    sql = "DELETE FROM course_classes WHERE id = $1;"
    values = [@id]
    SqlRunner.run( sql, values )
  end

  # show all classes for a venue
  def self.all_by_venue(id)
    sql = "SELECT * FROM course_classes WHERE venue_id = $1;"
    values = [id]
    results = SqlRunner.run( sql, values )
    return results.map{ |courseclass| CourseClass.new( courseclass )}
  end

  # update one course class

  def update()
    sql = "UPDATE course_classes SET (
    name, max_capacity, venue_id, membership_level
    ) = (
      $1, $2, $3, $4
    )
    WHERE id = $5;
    "
    values = [@name, @max_capacity, @venue_id, @membership_level, @id]
    SqlRunner.run( sql, values )
  end

  # find class by id
  def self.find( id )
    sql = "SELECT * FROM course_classes WHERE id = $1;"
    values = [id]
    result = SqlRunner.run( sql, values )
    return CourseClass.new( result.first )
  end

  # get venue name
  def venue_name()
    Venue.find(@venue_id).name()
  end

  # get number of members in a class
  def members_count()
    sql = "SELECT COUNT (*) FROM class_trackers WHERE course_class_id = $1;"
    values = [@id]
    result = SqlRunner.run( sql, values ).first['count'].to_i

  end

  # check if still availability
  def availability?
    return members_count() < @max_capacity
  end

  # check membership
  def correct_membership?(member)
    return member.membership == @membership_level
  end

  # add to class tracker
  def add_member(member)
    return if !availability?()
    sql = "INSERT INTO class_trackers
    (course_class_id, member_id)
    values
    ($1,$2);
    "
    values = [@id, member.id]
    SqlRunner.run( sql, values )
  end

  #remove from class class_tracker
  def remove_member(member)
    return if !member_booked_in?(member)
    sql = "DELETE FROM class_trackers WHERE member_id = $1 AND course_class_id = $2"
    values = [member.id, @id]
    SqlRunner.run( sql, values )
  end

  # book member in a class
  def book_member(member)
    return if !availability?()
    return if !member.active?()
    return if !correct_membership?(member)
    return if member_booked_in?(member)
    add_member(member)
  end

  # all members booked in a class
  def members_list
    return if members_count() == nil
    sql = "SELECT members.* FROM members
    INNER JOIN class_trackers
    ON class_trackers.member_id = members.id
    WHERE class_trackers.course_class_id = $1;
    "
    values = [@id]
    results = SqlRunner.run( sql, values )
    return results.map{ |member| Member.new(member)}
  end

  # is the member booked in a class?
  def member_booked_in?(member)
    return !members_list.find{ |x| x.id == member.id }.nil?
  end

  # get empty classes
  def self.empty_classes(venueid)
    empty_classes = []
    for courseclass in CourseClass.all_by_venue(venueid)
      if courseclass.members_count() == 0
        empty_classes << courseclass
      end
    end
    return empty_classes
  end

  def self.full_classes(venueid)
    full_classes = []
    for courseclass in CourseClass.all_by_venue(venueid)
      if courseclass.members_count() == courseclass.max_capacity
        full_classes << courseclass
      end
    end
    return full_classes
  end

end
