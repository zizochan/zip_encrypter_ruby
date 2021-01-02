require File.join(__dir__, 'classes/password_updater')

dir = ARGV[0]
PasswordUpdater.new(dir).update!

puts ''
puts 'all file password update complete'
puts "Don't forget to update password.txt"
