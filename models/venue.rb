require_relative( "../db/sql_runner" )

class Venue

  attr_reader :id, :name, :address, :max_number_classes, :course_classes 

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @address = options['address']
    @max_number_classes = options['max_number_classes']
    @course_classes = []
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
    values = [@name, @address, @max_number_classes ]
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

# #create a class
#
#   def self.add_course_class()
#     sql
#
#   end

end
