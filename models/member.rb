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

end
