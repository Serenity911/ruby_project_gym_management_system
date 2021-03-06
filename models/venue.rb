require_relative( "../db/sql_runner" )

class Venue

  attr_reader :id
  attr_accessor :name, :address, :max_number_classes

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @address = options['address']
    @max_number_classes = options['max_number_classes'].to_i
    # add till
  end

  # restful

  # create a venue

  def save()
    sql = "INSERT INTO venues
    (name, address, max_number_classes)
    VALUES
    ($1, $2, $3)
    RETURNING id"
    values = [@name, @address, @max_number_classes]
    @id = SqlRunner.run( sql, values ).first['id'].to_i
  end

  # delete all the venues

  def self.delete_all()
    sql = "DELETE FROM venues"
    SqlRunner.run( sql )
  end

  # show all the venues

  def self.all()
    sql = "SELECT * FROM venues"
    result = SqlRunner.run( sql )
    return result.map{|venue| Venue.new( venue )}
  end

  # delete one venue

  def destroy()
    sql = "DELETE FROM venues WHERE id = $1"
    values = [@id]
    SqlRunner.run( sql, values )
  end

  def update()
    sql = "UPDATE venues SET (
    name, address, max_number_classes
    ) = (
      $1, $2, $3
    )
    WHERE id = $4
    "
    values = [@name, @address, @max_number_classes, @id]
    SqlRunner.run( sql, values )
  end

  # find by id
  def self.find( id )
    sql = " SELECT * FROM venues WHERE id = $1"
    values = [id]
    result = SqlRunner.run( sql, values )
    return Venue.new( result.first )
  end

  # find how many classes it has
  def classes_counter()
    sql = "SELECT COUNT (*) FROM course_classes WHERE venue_id = $1"
    values = [@id]
    result = SqlRunner.run( sql, values )
    return  result.first['count'].to_i
  end


  # get all classes for venue
  def get_all_classes()
    sql = "SELECT * FROM venues
    INNER JOIN course_classes
    ON  venues.id = course_classes.venue_id
    WHERE course_classes.venue_id = $1;"
    values = [@id]
    result = SqlRunner.run( sql, values )
    return result.map{|course_c| CourseClass.new( course_c )}
  end



end
