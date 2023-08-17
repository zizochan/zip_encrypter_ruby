require File.join(__dir__, 'file_converter')
require File.join(__dir__, 'encrypter')
require File.join(__dir__, 'decrypter')

require 'find'
require 'zip'

class PasswordUpdater < FileConverter
  attr_accessor :dir, :files, :new_password

  WAIT_SECOND = 3

  def initialize(dir)
    super()

    set_dir(dir)
  end

  def update!
    set_files

    input_new_password

    wait_confirm

    update_all_password
  end

  private

  def set_dir(dir)
    @dir = dir

    error('USAGE: ruby all_file_password_update.rb DIRPATH') if blank?(dir)
    error("#{dir} is not directory") unless Dir.exist?(dir)
  end

  def set_files
    @files = get_zip_files

    error("#{dir} has no zip file") if files.empty?
  end

  def get_zip_files
    Find.find(dir).select { |file| File.extname(file) == '.zip' }
  end

  def wait_confirm
    wait_confirm_prompt

    unless are_you_ok?
      puts 'exit'
      exit
    end

    puts 'start...'
    sleep WAIT_SECOND

    true
  end

  def wait_confirm_prompt
    puts
    puts '================'
    puts 'files:'
    puts files
    puts ''
    puts 'new password:'
    puts new_password
  end

  def input_key(text)
    puts ''
    puts "[INPUT] #{text}:"

    $stdin.gets.chomp
  end

  def are_you_ok?
    loop do
      response = input_key('is it ok? (y|n)')

      case response
      when /^[yY]/
        return true
      when nil, ''
        # loop
      else
        return false
      end
    end
  end

  def input_new_password
    loop do
      @new_password = input_key('new zip password?')

      break unless blank?(new_password)
    end
  end

  def update_all_password
    files.each do |file|
      update_password(file)
    end
  end

  def update_password(file)
    puts file

    decrypt_files = zip_entry_files(file)
    Decrypter.new(file, with_trash: true, with_open_dir: false).decrypt!

    decrypt_files.each do |decrypt_file|
      Encrypter.new(decrypt_file, force_password: new_password).encrypt!
    end
  end

  def zip_entry_files(file)
    base_dir = File.dirname(file)
    zis = Zip::InputStream.open(file)

    files = []
    loop do
      entry = zis.get_next_entry
      break if entry.nil?

      files.push File.join(base_dir, entry.name.chomp)
    end

    files
  end
end
