require_relative( "../db/sql_runner" )

class Member

  attr_reader :id
  attr_accessor :name, :status, :membership


  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @status = options['status']
    @membership = options['membership']
    # add date
    # add days of week
    # add instructors
  end

  # create a member

  def save()
    sql = "INSERT INTO members
    (name, status, membership)
    VALUES
    ($1, $2, $3)
    RETURNING id"
    values = [@name, @status, @membership]
    @id = SqlRunner.run( sql, values ).first['id'].to_i
  end

  # delete all the members

  def self.delete_all()
    sql = "DELETE FROM members"
    SqlRunner.run( sql )
  end

  # show all the members

  def self.all()
    sql = "SELECT * FROM members"
    results = SqlRunner.run( sql )
    return results.map{|member| Member.new( member )}
  end

  # delete one member

  def destroy()
    sql = "DELETE FROM members WHERE id = $1"
    values = [@id]
    SqlRunner.run( sql, values )
  end

  # update one member

  def update()
    sql = "UPDATE members SET (
    name, status, membership
    ) = (
    $1, $2, $3
    )
    WHERE id = $4
    "
    values = [@name, @status, @membership, @id]
    SqlRunner.run( sql, values )
  end

  # archive
  def archive()
    sql = "UPDATE members SET status = $1
    WHERE id = $2
    "
    values = ["archived", @id]
    SqlRunner.run( sql, values )
  end

  # find by id
  def self.find( id )
    sql = " SELECT * FROM members WHERE id = $1"
    values = [id]
    result = SqlRunner.run( sql, values )
    return Member.new( result.first )
  end

  # check if member is active
  def active?
    @status == "active"
  end

  def attendance()
    sql = "SELECT course_classes.* FROM course_classes
    INNER JOIN class_trackers
    ON class_trackers.course_class_id = course_classes.id
    WHERE class_trackers.member_id = $1"
    values = [@id]
    results = SqlRunner.run( sql, values )
    return results.map{ |courseclass| CourseClass.new(courseclass)}
  end

  # show all for a specific status

  def self.all_by_status(status)
    sql = "SELECT * FROM members WHERE status = $1"
    values = [status]
    results = SqlRunner.run( sql, values )
    return results.map{|member| Member.new( member )}

  end

  def self.all_by_membership(status, membership)
      # sql = "SELECT * FROM members WHERE membership = $1"
      # values = [membership]
      # results = SqlRunner.run( sql, values )
      # return results.map{|member| Member.new( member )}
      @all_by_status = Member.all_by_status(status)
      @members_status_membership = []
      for one in @all_by_status
        if one.membership == membership
          @members_status_membership << one
        end
      end
      return @members_status_membership
  end

  def self.all_bookable(course_class, status, membership)
      @all_membership = Member.all_by_membership(status, membership)
      @all_bookable = []
      for one in @all_membership
        if course_class.member_booked_in?(one)
        else
          @all_bookable << one
        end
      end
      return @all_bookable
  end

end
