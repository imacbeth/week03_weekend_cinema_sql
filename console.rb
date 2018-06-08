require('pry')
require_relative('./models/ticket')
require_relative('./models/customer')
require_relative('./models/film')

# Ticket.delete_all()
Customer.delete_all()
 # Film.delete_all()

customer1 = Customer.new({
  'name' => 'Iona',
  'funds' => 20
  })
customer1.save()

customer2 =  Customer.new({
  'name' => 'Callum',
  'funds' => 40
  })
customer2.save()

film1 = Film.new({
  'title' => 'Solo',
  'price' => 8
  })
film1.save()

film2 = Film.new({
  'title' => 'A Quiet Place',
  'price' => 8
  })
film1.save()

binding.pry
nil
