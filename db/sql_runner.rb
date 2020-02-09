require( 'pg' )

class SqlRunner


  def self.run( sql, values = [] )
    begin
      db = PG.connect({  :access_key_id   => ENV['S3_KEY'],
 :secret_access_key => ENV['S3_SECRET']})
      db.prepare("query", sql)
      result = db.exec_prepared( "query", values )
    ensure
      db.close() if db != nil
    end
    return result
  end

end
