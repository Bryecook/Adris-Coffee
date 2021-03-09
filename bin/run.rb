require_relative '../config/environment'
require 'pry'

def location_selection
    cities=City.all.map {|city| city.name}
    prompt = TTY::Prompt.new
    city_choice = prompt.select("Please select a city:", cities)
    locations=Location.all.select {|location| location.city.name==city_choice}
    location_names=locations.map{|location| location.name}
    if city_choice=="Austin"
        location_choice = prompt.select("Please select a location:", location_names)
        #puts "You have selected #{location_choice} in #{city_choice}! Now it's time to pick your drinks!"
    else
        location_choice = prompt.select("Please select a location:", location_names)
        #puts "You have selected #{location_choice} in #{city_choice}! Now it's time to pick your drinks!"
    end
    puts "You have selected #{location_choice} in #{city_choice}! Now it's time to pick your drinks!"
end


#binding.pry
location_selection

puts "HELLO WORLD"
