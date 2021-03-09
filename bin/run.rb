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
    prompt = TTY::Prompt.new
    login_create = prompt.select("Let's drink coffee!", ["Login", "Sign Up", "Exit"])
    if (login_create == "Login")
        current_username = prompt.ask("What is your username?")
        current_password = prompt.mask("What is your password?")
        if clients.include?(current_username) && Client.all.find_by(password: current_password)
            puts ("Hello #{current_username}, what would you like to drink?")
        elsif
          puts "Incorrect username or password. Please try again or Sign up"
           
        end

    elsif (login_create == "Sign Up")
        new_username = prompt.ask("Username")
        if clients.include?(new_username)
            puts "This username isn't available. Please try another"
      
        end 
        new_password = prompt.mask("Password")
        Client.create(username: new_username, password: new_password)
            puts "Welcome #{new_username}, what would you like to drink?"

    else 
        exit!
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
