require_relative('../db/sql_runner')
require_relative('film.rb')
require_relative('customer.rb')

class Ticket

  attr_accessor :film_id, :customer_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id']
    @customer_id = options['customer_id']
  end

  def save()
    sql = "INSERT INTO tickets
    (film_id, customer_id)
    VALUES ($1, $2)
    RETURNING id"
    values = [@film_id, @customer_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end


end
