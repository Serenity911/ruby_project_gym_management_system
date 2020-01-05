require_relative( "../db/sql_runner" )

class Membership

  attr_reader :id
  attr_accessor :name, :price, :deactivated


  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @price = options['price'].to_i
    @deactivated = options['deactivated']
  end

  # create a membership

  def save()
    sql = "INSERT INTO memberships
    (name, price)
    VALUES
    ($1, $2)
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
    name, price
    ) = (
      $1, $2
    )
    WHERE id = $3
    "
    values = [@name, @price, @id]
    SqlRunner.run( sql, values )
  end


  # deactivate a membership
  def deactivate()
    sql = "UPDATE memberships SET deactivated = 1 WHERE id = $1;"
    values = [@id]
    SqlRunner.run( sql, values )
  end


end
