require_relative( " ../db/sql_runner" )

class Venue

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
    @id = SqlRunner.run( sql, runner ).first['id'].to_i
  end


# #create a class
#
#   def self.add_course_class()
#     sql
#
#   end

end
