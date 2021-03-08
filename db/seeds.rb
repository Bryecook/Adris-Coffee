
City.destroy_all
Locations.destroy_all
Drinks.destroy_all
Client.destroy_all
Order.destroy_all

austin = City.create(name: "Austin", state: "Texas")
houston = City.create(name: "Houston", state: "Texas")
# dallas = City.create("Dallas", "Texas")

south_austin = Location.create(name: "South", address: "1509 S Lamar Blvd", city_id: austin.id)
north_austin = Location.create(name: "North", address: "1700 W Parmer Ln", city_id: austin.id)
south_houston = Location.create(name: "South", address: "1035 N Shepard Dr", city_id: houston.id)
north_houston = Location.create(name: "North", address: "5820 W. Sam Houston Pkwy ", city_id: houston.id)

americano = Drink.create(name: "Americano", price: 3)
latte = Drink.create(name: "Latte", price: 5)
cappuccino = Drink.create(name: "Cappuccino", price: 5)
espresso = Drink.create(name: "Espresso", price: 4)

client1 = Client.create(name: "Adritorres", password: "ilovemycat")
client2 = Client.create(name: "Bryecook", password: "musicislife")
client3 = Client.create(name: "Angelo", password: "dopeshirt")
client4 = Client.create(name: "Nestor", password: "stayhydrated")
client5 = Client.create(name: "Raul", password: "onthatnote")

order1 = Order.create(client_id: client1.id, drink_id: latte.id, location_id: south_austin.id)
order2 = Order.create(client_id: client2.id, drink_id: americano.id, location_id: north_austin.id)
order3 = Order.create(client_id: client5.id, drink_id: espresso.id, location_id: north_houston.id)
order4 = Order.create(client_id: client4.id, drink_id: latte.id, location_id: south_houston.id)
order5 = Order.create(client_id: client3.id, drink_id: cappuccino.id, location_id: north_houston.id)
