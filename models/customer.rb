require_relative( '../db/sql_runner' )
require_relative('./film.rb')
require_relative('./ticket.rb')

class Customer

attr_accessor :funds, :name
attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save()
    sql = "INSERT INTO customers (name, funds)
    VALUES ($1, $2)
    RETURNING id"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def update
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    result = Customer.map_items(customers)
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def self.map_items(customer_data)
    result = customer_data.map { |person| Customer.new(person) }
    return result
  end

  def films
    sql = "SELECT films.*
    FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    WHERE customer_id = $1"
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    return Film.map_items(film_data)
  end

  def check_funds
    sql = "SELECT funds FROM customers WHERE id = $1"
    values = [@id]
    funds = SqlRunner.run(sql, values)
    return funds
  end

  def tickets_bought()
    sql = "SELECT tickets.*
    FROM tickets
    WHERE customer_id = $1"
    values = [@id]
    tickets_count = SqlRunner.run(sql, values).count
    return tickets_count
  end


  def buy_ticket(film)
    @funds -= film.price()
    Customer.update(@name, @funds)
    ticket = Ticket.new({'customer id' => @id, 'film_id' => film.id})
    ticket.save()
  end

end
