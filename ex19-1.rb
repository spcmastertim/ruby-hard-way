puts "playing with functions"

def cars_and_trucks(num_cars, num_trucks)
  puts "You have #{num_cars} cars on the road"
  puts "You have #{num_trucks} trucks on the road"
end

cars_and_trucks(32, 40)

puts "How many cars are on the road?"
num_cars = $stdin.gets.chomp
puts "How many trucks are on the road?"
num_trucks = $stdin.gets.chomp

cars_and_trucks(num_cars, num_trucks)
