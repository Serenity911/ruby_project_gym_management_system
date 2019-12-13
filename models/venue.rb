require_relative( " ../db/sql_runner" )

class Venue

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @address = options['address']
    @max_number_classes = options['max_number_classes']
    # add till

  end

end
