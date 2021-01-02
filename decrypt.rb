require File.join(__dir__, 'classes/decrypter')

file = ARGV[0]
Decrypter.new(file).decrypt!

puts "#{file} has been zip decryption"
