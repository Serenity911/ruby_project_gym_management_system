require( 'pg' )
DATABASE_URL=$(heroku config:get DATABASE_URL -a gym-managemement-app)

class SqlRunner


  def self.run( sql, values = [] )
    begin
      db = PG.connect({ DATABASE_URL })
      db.prepare("query", sql)
      result = db.exec_prepared( "query", values )
    ensure
      db.close() if db != nil
    end
    return result
  end

end
