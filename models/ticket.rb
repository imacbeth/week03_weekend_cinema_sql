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

  def update
    sql = "UPDATE tickets SET film_id = $1, customer_id = $2 WHERE id = $3"
    values = [@film_id, @customer_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
      sql = "SELECT * FROM tickets"
      tickets = SqlRunner.run(sql)
      result = Ticket.map_items(tickets)
      return result
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def self.map_items(ticket_data)
    result = ticket_data.map { |ticket| Ticket.new( ticket ) }
    return result
  end

  def film
    sql = "SELECT *
    FROM films
    WHERE id = $1"
    values = [@film_id]
    film = SqlRunner.run(sql, values).first
    return Film.new(film)
  end

  def customer
    sql = "SELECT *
    FROM customers
    WHERE id = $1"
    values = [@customer_id]
    customer = SqlRunner.run(sql, values).first
    return Customer.new(customer)
  end

end
