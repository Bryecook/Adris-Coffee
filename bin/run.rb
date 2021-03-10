require_relative '../config/environment'
require 'pry'
require "tty-prompt"
require 'colorize'

def welcome 
    title = Artii::Base.new(:font => "big")
    puts "Welcome to:"
    puts title.asciify("Adri's Coffee").colorize(:green)
   puts "  (  )   (   )  )
   ) (   )  (  (
   ( )  (    ) )
   _____________
  <_____________> ___
  |             |/ _ \
  |               | | |
  |               |_| |
___|             |\___/
/    \___________/    \
\_____________________/
".colorize(:red)
end 

def login_create
client_object=nil
clients = Client.all.map {|client| client.username}
logged_in = false
    prompt = TTY::Prompt.new
   while logged_in==false do
     login_create = prompt.select("Let's drink coffee!", ["Login", "Sign Up", "Exit"])
    if (login_create == "Login")
        current_username = prompt.ask("What is your username?")
        if clients.include?(current_username)
            current_password = prompt.mask("What is your password?") 
            if Client.all.select {|client| client.username==current_username}.first.password==current_password
                logged_in=true
                client_object=Client.all.select {|client| client.username==current_username}.first
                puts ("Hello #{current_username}, what would you like to drink?")
            else 
                forgot_password = prompt.select("Incorrect password. Did you forget your password?", ["Yes", "No"])
                    if forgot_password == "Yes"
                        loop do
                            confirm_username= prompt.ask("Please confirm your username.")
                            if clients.include?(confirm_username)
                                restored_password = prompt.mask("Please enter new password.")
                                Client.all.select {|client| client.username==confirm_username}.first.update(password: restored_password)
                            break
                            else
                                incorrect_username = prompt.select("No username match. Do you want to try again or sign up a new account?", ["Try again", "Sign Up"])
                                    if incorrect_username=="Try again"
                                    else
                                        logged_in=false
                                        break
                                    end
                            end
                        end
                    else
                        logged_in=false
                        puts "Please try again or sign up for a new account!"
                    end
                
                end
            else
                logged_in=false
                puts "Incorrect username. Please try again."
            end   
    elsif (login_create == "Sign Up")
        new_username = nil
        loop do
            new_username = prompt.ask("Username")
            if clients.include?(new_username)
                puts "This username isn't available. Please try another"
            else
                new_username
                break
            end
            
        end
        binding.pry
        new_password = prompt.mask("Password")
        client_object=Client.create(username: new_username, password: new_password, balance: 0, rewards: 0)
            puts "Welcome #{new_username}, what would you like to drink?"
            logged_in=true
    else 
        exit!
    end
    end
    client_object
end  

def location_selection
    location_object=nil
    cities=City.all.map {|city| city.name}
    prompt = TTY::Prompt.new
    city_choice = prompt.select("Please select a city:", cities)
    locations=Location.all.select {|location| location.city.name==city_choice}
    location_names=locations.map{|location| location.name}
    if city_choice=="Austin"
        location_choice = prompt.select("Please select a location:", location_names)
    else
        location_choice = prompt.select("Please select a location:", location_names)
    end
    location_object=Location.all.select {|location| location.name==location_choice}.first
    puts "You have selected #{location_choice} in #{city_choice}! Now it's time to pick your drinks!"
    location_object
end

def add_money(client)
    prompt = TTY::Prompt.new
    add_money = prompt.select("Select an amount to add to your account", ["15", "25", "Other"])
    if (add_money == "15")
        client.balance += 15
        client.update(balance: client.balance)
    elsif (add_money == "25")
        client.balance += 25
        client.update(balance: client.balance)
    else 
        puts "Enter an amount"
        client.balance = gets.to_i
        client.update(balance: client.balance)
    end 
end 


def add_rewards(client, drink)
    client.rewards += drink.price
    "You collected #{drink.price} points!"
end 

#binding.pry
client1 = Client.create(username: "Luca", password: "bottle", balance: 0, rewards: 0)
mocha = Drink.create(name: "Mocha", price: 3)

# add_rewards(client1, mocha)


def add_to_cart
    drinks = Drink.all.map {|drink| drink.name}
    prompt = TTY::Prompt.new
    drink_option = prompt.select("Select your Coffee:", drinks)


def place_an_order(client)
    drinks = Drink.all.map {|drink| drink.name }
    prompt = TTY::Prompt.new
    # loop do
    drink_option = prompt.select("Select your Coffee:", drinks)
    binding.pry
    drink=Drink.all.select {|drink| drink.name == drink_option}.first
        if client.balance >= drink.price
        client.balance -= drink.price
        puts ("Enjoy your #{drink_option}!").colorize(:yellow)
        #current_order = >>> I've tried different ways to save the drink ordered but still not working, need to come back to it 
        else
        puts ("Please check your account balance and try again.").colorize(:yellow)
        #add_money(client_object)
        ##can we call a method inside another method? 
        end
    menu_options = prompt.select("Would you like to add another drink to your order?", ["Yes", "No, thank you. Sign out"])
        if menu_options == "Yes"
          #neeeds to add a loop to go to the beginning of the method
          #if we want the order receipt you mentioned, we will need to save the drink ordered before it loops back, so we have all the drinks 
          #maybe we can create a variable called current_order and save the drinks (I was working on it, line 99) 
        elsif menu_options == "No, thank you. Sign out"
            puts ("We are working on your order!").colorize(:yellow)
            title = Artii::Base.new(:font => "big")
            puts title.asciify("Thank you!").colorize(:green)
        end
        exit!
    end
    # end

welcome
client_object=login_create
location_object=location_selection
loop do
    prompt = TTY::Prompt.new
    selection=prompt.select("What would you like to do?", ["Place order", "Check balance", "Check reward balance", "Add funds", "Exit/Sign Out"])
        if selection=="Place order"
            break
        elsif selection=="Check balance"
            puts "Your balance is $#{client_object.balance}."
        elsif selection=="Check reward balance"
            puts "Your reward balance is #{client_object.rewards}."
        elsif selection=="Add funds"
            add_money(client_object)
            puts "Your new balance is $#{client_object.balance}."
        else
            exit!
        end
    end 
drink_object=add_to_cart
#output of the object 
order_purchase(client_object_id, location_object_id, drink_object_id)
#make the order object with location,client,drink ids
#verifies balance >= drink price/gives option to add funds if not enough funds in balance
#updates reward points
#prints out order_id as the receipt.


binding.pry


binding.pry
0

