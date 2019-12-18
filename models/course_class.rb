require_relative( "../db/sql_runner" )
require_relative( "./membership" )


class CourseClass

  attr_reader :id, :max_capacity, :venue_id, :membership_id, :course_date
  attr_accessor :name

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @course_date = options['course_date']
    @max_capacity = options['max_capacity'].to_i
    @venue_id = options['venue_id'].to_i
    @membership_id = options['membership_id'].to_i
    # add days of week
    # add instructors
  end

  # EXT1
  # create a course_class

  def save()
    # if Venue.find(@venue_id).is_full
    #   return
    # else
    sql = "INSERT INTO course_classes
    (name, course_date, max_capacity, venue_id, membership_id)
    VALUES
    ($1, $2, $3, $4, $5)
    RETURNING id;"
    values = [@name, @course_date, @max_capacity, @venue_id, @membership_id]
    @id = SqlRunner.run( sql, values ).first['id'].to_i
    # end
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
    name, course_date, max_capacity, venue_id, membership_id
    ) = (
      $1, $2, $3, $4, $5
    )
    WHERE id = $6;
    "
    values = [@name, @course_date, @max_capacity, @venue_id, @membership_id, @id]
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
    return member.membership_id == @membership_id
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

  # remove member from a class
  def cancel_booking(member)
    return if !member_booked_in?(member)
    remove_member(member)
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

  def membership()
    sql = "SELECT memberships.name FROM memberships
    INNER JOIN course_classes
    ON course_classes.membership_id = memberships.id
    WHERE course_classes.membership_id = $1
    ;"
    values = [@membership_id]
    return SqlRunner.run( sql, values ).first['name']
  end

  def week_availability?
    sql = "SELECT COUNT(*) AS count FROM course_classes AS cc WHERE cc.venue_id = $1 AND EXTRACT('week' FROM cc.course_date)=EXTRACT('week' FROM DATE($2)) AND  EXTRACT('year' FROM cc.course_date)=EXTRACT('year' FROM DATE($2));"
    values = [@venue_id, @course_date]
    result = SqlRunner.run( sql, values ).first['count'].to_i
    return result < Venue.find(@venue_id).max_number_classes
  end

  def save_if_availability()
    if self.week_availability?
      self.save
    else
      return
    end

  end



end
