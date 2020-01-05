require_relative( "../db/sql_runner" )

class Membership

  attr_reader :id
  attr_accessor :name, :price, :active


  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @price = options['price'].to_i
    @active = options['active'].to_i
  end

  # create a membership

  def save()
    sql = "INSERT INTO memberships
    (name, price, active)
    VALUES
    ($1, $2, 1)
    RETURNING id"
    values = [@name, @price]
    @id = SqlRunner.run( sql, values ).first['id'].to_i
  end

  # delete all the memberships

  def self.delete_all()
    sql = "DELETE FROM memberships"
    SqlRunner.run( sql )
  end

  # show all the memberships

  def self.all()
    sql = "SELECT * FROM memberships"
    results = SqlRunner.run( sql )
    return results.map{|membership| Membership.new( membership)}
  end

  # delete one membership

  def destroy()
    sql = "DELETE FROM memberships WHERE id = $1"
    values = [@id]
    SqlRunner.run( sql, values )
  end

  def self.get_id(name)
    sql = "SELECT id FROM memberships
    WHERE name = $1
    ;"
    values = [name]
    return SqlRunner.run( sql, values ).first['id'].to_i
  end

  # find by id
  def self.find( id )
    sql = " SELECT * FROM memberships WHERE id = $1"
    values = [id]
    result = SqlRunner.run( sql, values )
    return Membership.new( result.first )
  end

  # update one membership

  def update()
    sql = "UPDATE memberships SET (
    name, price, active
    ) = (
      $1, $2, $3
    )
    WHERE id = $4
    "
    values = [@name, @price, @active, @id]
    SqlRunner.run( sql, values )
  end


  # deactivate a membership
  def deactivate()
    sql = "UPDATE memberships SET active = 0 WHERE id = $1;"
    values = [@id]
    SqlRunner.run( sql, values )
  end

  # deactivate a membership
  def reactivate()
    sql = "UPDATE memberships SET active = 1 WHERE id = $1;"
    values = [@id]
    SqlRunner.run( sql, values )
  end

  # list of classes with membership
  def get_courseclass()
    sql = "SELECT * FROM course_classes WHERE membership_id =$1"
    values = [@id]
    results = SqlRunner.run( sql, values )
    return results.map{|course_c| CourseClass.new(course_c)}
  end

end
