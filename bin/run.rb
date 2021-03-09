require_relative '../config/environment'
require 'pry'
require "tty-prompt"
require 'colorize'




def add_money(client)
    prompt = TTY::Prompt.new
    add_money = prompt.select("Select an amount to add to your account", ["15", "25", "Other"])
    if (add_money == "15")
    client.balance += 15
elsif (add_money == "25")
    client.balance += 25
else 
    puts "Enter an amount"
    client.balance = gets.to_i
end 
end 


def add_rewards(client, drink)
    client.rewards += drink.price
    puts "You collected #{drink.price} points!"
end 



# client1 = Client.create(username: "Luca", password: "bottle", balance: 0, rewards: 0)
# mocha = Drink.create(name: "Mocha", price: 3)

# add_rewards(client1, mocha)


# binding.pry
0
