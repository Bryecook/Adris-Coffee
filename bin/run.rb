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
        unused_username = false
        while unused_username == false do
        new_username = prompt.ask("Username")
        if clients.include?(new_username)
            puts "This username isn't available. Please try another"
            unused_username = false
        else
            unused_username = true
        end 
        end
        new_password = prompt.mask("Password")
        Client.create(username: new_username, password: new_password)
            puts "Welcome #{new_username}, what would you like to drink?"
            logged_in=true
    else 
        exit!
    end
    end
end  


def place_an_order
    drinks = Drink.all.map {|drink| drink.name }
    prompt = TTY::Prompt.new
    drink_option = prompt.select("Select your Coffee:", drinks)
    puts ("Enjoy your #{drink_option}!").colorize(:yellow)
    menu_options = prompt.select("Would you like to add another drink to your order?", ["Yes", "No, thank you. Sign out"])
    if menu_options == "Yes"
      place_an_order
    else
        puts ("We are working on your order!").colorize(:yellow)
    title = Artii::Base.new(:font => "big")
    puts title.asciify("Thank you!").colorize(:green)
    end
    exit!
end


welcome
login_create
place_an_order


# binding.pry
