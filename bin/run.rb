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
  |             |/ _ |
  |               | ||
  |               |_||
  |             |\___/
   | ___________/    

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
                puts ("Hello #{current_username}, Where would you like to go to?").colorize(:yellow)
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
    puts ("You have selected #{location_choice} in #{city_choice}! Now it's time to pick your drink!").colorize(:yellow)
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
        puts ("Enter an amount").colorize(:yellow)
        client.balance = gets.to_i
        client.update(balance: client.balance)
    end 
end 

def add_to_cart
    drink_object=nil
    drinks = Drink.all.map {|drink| drink.name }
    options = Drink.all.map {|drink| drink.name }
    options << "Exit/Sign Out"
    prompt = TTY::Prompt.new
    drink_option = prompt.select("Select your Coffee:", options)   
    if  drinks.include?(drink_option)
        drink_object=Drink.all.select {|drink| drink.name == drink_option}.first
        puts ("One #{drink_option} coming right up!").colorize(:yellow)
        drink_object 
    else 
        options == "Exit/Sign Out"
        puts ("Goodbye! Hope to see you again soon").colorize(:yellow)
        exit!
end 
end


def order_purchase(client, drink, location)
    order_object=nil
    loop do
        prompt = TTY::Prompt.new
        selection=prompt.select("How would you like to purchase your drink?", ["With account balance", "With rewards balance", "Exit/cancel order"])
        if selection=="With account balance"
            puts ("Checking account balance...").colorize(:yellow)
            if client.balance >= drink.price
                new_balance = client.balance - drink.price
                client.update(balance: new_balance)
                new_reward_balance = client.rewards + drink.price
                client.update(rewards: new_reward_balance)
                puts ("Purchase successful! You have $#{client.balance} left in your account.").colorize(:yellow)
                puts ("You have also earned #{drink.price} more reward points and have a total of #{client.rewards}!").colorize(:yellow)
                break
            else
                prompt = TTY::Prompt.new
                balance_selection=prompt.select("Insufficient funds. Would you like to:", ["Add funds to account", "Go back to purchase menu", "Exit/cancel order"])
                if balance_selection == "Add funds to account"
                    add_money(client)
                elsif balance_selection == "Go back to purchase menu"
                
                else 
                    puts "Goodbye! Hope to see you again soon"
                    exit!
                end
            end
        elsif selection == "With rewards balance"
            if client.rewards >= drink.reward_cost
                new_reward_balance = client.rewards - drink.reward_cost
                client.update(rewards: new_reward_balance)
                puts ("Purchase successful! Your new reward balance is #{client.rewards}").colorize(:yellow)
                break
            else
                more_points_needed = drink.reward_cost - client.rewards
                puts ("Insufficient reward balance. You need #{more_points_needed} more reward points to make this purchase.").colorize(:yellow)
            end
        else
            puts ("Goodbye! Hope to see you again soon!").colorize(:yellow)
            exit!
        end
    end
    order_object = Order.create(client_id: client.id, location_id: location.id, drink_id: drink.id)
    ready= rand(10..20)
    puts ("Your order and receipt number is #{order_object.id}. Your order will be ready in #{ready} minutes!").colorize(:yellow)
    order_object
end

def add_a_tip(client)
    prompt = TTY::Prompt.new
    tip = prompt.select("Would you like to add a tip?", ["$1", "$2", "No, thank you"])
    if (tip == "$1")
        if client.balance >= 1
        client.balance -= 1
        client.update(balance: client.balance)
        puts ("We are working on your order").colorize(:yellow)
        else
            puts "Insufficient funds"
        end 
    elsif (tip == "$2")
        if client.balance >= 2
            client.balance -= 2
            client.update(balance: client.balance)
            puts ("We are working on your order").colorize(:yellow)
        else 
                puts "Insufficient funds"
        end
    else 
        puts ("We are working on your order").colorize(:yellow)
    end 
end 

def cancel_order(order)
    prompt = TTY::Prompt.new
    selection=prompt.select("Thank you for your business. You may now exit or cancel order.", ["Exit/Sign out", "Cancel order"])
    if selection == "Exit/Sign out"
        puts "Goodbye! See you at the store!"
    else
        puts "Your order has been canceled. Please call our customer service line to be issued a refund."
        # drinkid=order.drink_id
        # drink_selection=Drink.all.select{|drink| drink.id==drinkid}.first
        # clientid=order.client_id
        # client_selection=Client.all.select{|client| client.id==clientid}.first
        # refund= client_selection.balance + drink_selection.price
        # client_selection.update(balance: refund)
        Order.delete(order.id)
        exit!
    end
end
    

welcome
client_object=login_create
location_object=location_selection
loop do
    prompt = TTY::Prompt.new
    selection=prompt.select("What would you like to do?", ["Place order", "Check balance", "Check reward balance", "Add funds", "Exit/Sign Out"])
        if selection=="Place order"
            break
        elsif selection=="Check balance"
            puts ("Your balance is $#{client_object.balance}.").colorize(:yellow)
        elsif selection=="Check reward balance"
            puts ("Your reward balance is #{client_object.rewards}.").colorize(:yellow)
        elsif selection=="Add funds"
            add_money(client_object)
            puts ("Your new balance is $#{client_object.balance}.").colorize(:yellow)
        else
            exit!
        end
    end 
drink_object=add_to_cart
order_object=order_purchase(client_object, drink_object, location_object)
add_a_tip(client_object)
cancel_order(order_object)
title = Artii::Base.new(:font => "big")
    puts title.asciify("Thank you!").colorize(:green)

