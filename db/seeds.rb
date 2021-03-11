
City.destroy_all
Location.destroy_all
Drink.destroy_all
Client.destroy_all
Order.destroy_all

austin = City.create(name: "Austin", state: "Texas")
houston = City.create(name: "Houston", state: "Texas")
# dallas = City.create("Dallas", "Texas")

south_austin = Location.create(name: "South", address: "1509 S Lamar Blvd", city_id: austin.id)
north_austin = Location.create(name: "North", address: "1700 W Parmer Ln", city_id: austin.id)
south_houston = Location.create(name: "South", address: "1035 N Shepard Dr", city_id: houston.id)
north_houston = Location.create(name: "North", address: "5820 W. Sam Houston Pkwy ", city_id: houston.id)

americano = Drink.create(name: "Americano", price: 3, reward_cost: 30)
latte = Drink.create(name: "Latte", price: 5, reward_cost: 50)
cappuccino = Drink.create(name: "Cappuccino", price: 5, reward_cost: 50)
espresso = Drink.create(name: "Espresso", price: 4, reward_cost: 40)

client1 = Client.create(username: "Adritorres", password: "ilovemycat", balance: 0, rewards:0)
client2 = Client.create(username: "Bryecook", password: "musicislife", balance: 0, rewards:0)
client3 = Client.create(username: "Angelo", password: "dopeshirt", balance: 0, rewards:0)
client4 = Client.create(username: "Nestor", password: "stayhydrated", balance: 0, rewards:0)
client5 = Client.create(username: "Raul", password: "onthatnote", balance: 0, rewards:0)

order1 = Order.create(client_id: client1.id, drink_id: latte.id, location_id: south_austin.id)
order2 = Order.create(client_id: client2.id, drink_id: americano.id, location_id: north_austin.id)
order3 = Order.create(client_id: client5.id, drink_id: espresso.id, location_id: north_houston.id)
order4 = Order.create(client_id: client4.id, drink_id: latte.id, location_id: south_houston.id)
order5 = Order.create(client_id: client3.id, drink_id: cappuccino.id, location_id: north_houston.id)
