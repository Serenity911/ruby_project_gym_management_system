require_relative( "../db/sql_runner" )

class Members

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @status = options['status']
    @membership = options['membership']
    # add date
    # add days of week
    # add instructors
  end

  # def save()
  #   sql = 'INSERT INTO member'
  #
  # end

end
