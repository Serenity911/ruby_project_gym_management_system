require_relative( "../db/sql_runner" )

class CourseClass

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @max_capacity = options['']
    # add date
    # add days of week
    # add instructors
  end

end
