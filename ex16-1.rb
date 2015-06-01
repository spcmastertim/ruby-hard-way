filename = ARGV.first

puts "The file #{filename} has the following contents:"
filedata = open(filename)
text = filedata.read
puts "#{text}"
filedata.close
