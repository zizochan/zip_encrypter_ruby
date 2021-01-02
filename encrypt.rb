require File.join(__dir__, 'classes/encrypter')

file = ARGV[0]
Encrypter.new(file).encrypt!

puts "#{file} has been zip encryption"
