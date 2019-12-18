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

  # EXT1 what if I want to count a max n. class per week
  #   def classes_counter()
  #     sql = "with course_date as (
  #     select min(date_trunc('week', course_date)) as startw,
  #     max(date_trunc('week', course_date)) as endw
  #     from course_classes
  #     WHERE venue_id = $1
  #   ),
  #   weeks as (
  #     select generate_series(startw, endw, '7 days') as week
  #     from course_date
  #   )
  #
  #   select w.week, count(i)
  #   from weeks w left outer join
  #   course_classes i
  #   on date_trunc('week', i.course_date) = w.week
  #   group by w.week;"
  #   values = [@id]
  #   result = SqlRunner.run( sql, values )
  #   return  result.first['count'].to_i
  # end
  #
  # def classes_per_week()
  #   sql = "SELECT COUNT(*) AS count FROM course_classes AS cc WHERE cc.venue_id = $1 AND EXTRACT('week' FROM cc.course_date)=EXTRACT('week' FROM DATE('2019-12-21')) AND  EXTRACT('year' FROM cc.course_date)=EXTRACT('year' FROM DATE('2019-12-21'));"
  #   values = [@id, @]
  #   result = SqlRunner.run( sql, values )
  #   return  result.first['count'].to_i
  # end


  # EXT1
  # find how many classes it has
  def classes_counter()
    sql = "SELECT COUNT (*) FROM course_classes WHERE venue_id = $1"
    values = [@id]
    result = SqlRunner.run( sql, values )
    return  result.first['count'].to_i
  end

  # find if full

  # def is_full()
  #   return classes_counter() == @max_number_classes
  # end


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
