require_relative( "../db/sql_runner" )
require_relative( "./membership" )


class Member

  attr_reader :id
  attr_accessor :name, :status


  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @status = options['status']
    # @membership_id = options['membership_id'].to_i
  end

  # create a member

  def save()
    sql = "INSERT INTO members
    (name, status)
    VALUES
    ($1, $2)
    RETURNING id"
    values = [@name, @status]
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
    name, status
    ) = (
    $1, $2
    )
    WHERE id = $3
    "
    values = [@name, @status, @id]
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

  # reactivate
  def reactivate()
    sql = "UPDATE members SET status = $1
    WHERE id = $2
    "
    values = ["active", @id]
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

#
  def self.all_by_membership(status, membership_id)
    sql = "SELECT * FROM memberships_members
    INNER JOIN members
    ON members.id = memberships_members.member_id
    WHERE memberships_members.membership_id = $1 AND members.status = $2;
    "
    values = [membership_id, status]
    results = SqlRunner.run( sql, values )
    return results.map{|member| Member.new( member )}

      # # sql = "SELECT * FROM members WHERE membership = $1"
      # # values = [membership]
      # # results = SqlRunner.run( sql, values )
      # # return results.map{|member| Member.new( member )}
      # @all_by_status = Member.all_by_status(status)
      # @members_status_membership = []
      # for one in @all_by_status
      #   if one.membership_id == membership_id
      #     @members_status_membership << one
      #   end
      # end
      # return @members_status_membership
  end

# add membership
  def add_membership(membership)
    return if membership.deactivated == 1
    sql = "INSERT INTO memberships_members
    (membership_id, member_id)
    VALUES
    ($1, $2);"
    values = [membership.id, @id]
    results = SqlRunner.run( sql, values )
  end

# remove membership
  def remove_membership(membership)
    return if has_membership?.nil
    sql = "DELETE FROM memberships_members
    WHERE membership_id = $1 AND member_id = $2;"
    values = [membership.id, @id]
    results = SqlRunner.run( sql, values )
  end

# check if member has membership
# check in memberships_members if member has membership
  def has_membership?(membership)
     sql = "SELECT * FROM memberships_members
     WHERE membership_id = $1 AND member_id = $2;"
     values = [membership.id, @id]
     results = SqlRunner.run( sql, values )
     return !results.nil?
     # if results != nil
     #   true
     # else
     #   false
     # end
  end

# or
# all_by_membership.find{ |x| x.id  == @id}
#


  def self.all_bookable(course_class, status, membership_id)
      @all_membership = Member.all_by_membership(status, membership_id)
      @all_bookable = []
      for one in @all_membership
        if course_class.member_booked_in?(one)
        else
          @all_bookable << one
        end
      end
      return @all_bookable
  end

  # todo check if useful

  def get_membership()
    sql = "SELECT memberships.* FROM memberships
    INNER JOIN memberships_members
    ON memberships_members.membership_id = memberships.id
    INNER JOIN members
    ON memberships_members.member_id = members.id
    WHERE members.id = $1
    ;"
    values = [@id]
    results = SqlRunner.run( sql, values )
    return Membership.new(results.first)
  end

end
