require 'pry'

class FileConverter
  PASSWORD_FILE = 'password.txt'.freeze

  private

  def set_password(force_password: nil)
    @password = force_password || read_password

    error("#{PASSWORD_FILE} is empty") if blank?(@password)
  end

  def get_password_file
    base_dir = File.expand_path('..', __dir__)
    File.join(base_dir, PASSWORD_FILE)
  end

  def read_password
    password_file = get_password_file

    error("write zip password in #{PASSWORD_FILE}") unless File.exist?(password_file)

    read_password_file(password_file)
  end

  def read_password_file(password_file)
    File.read(password_file).chomp
  end

  def blank?(text)
    text.nil? || text == ''
  end

  def error(text)
    raise "[ERROR] #{text}"
  end

  def set_file(file)
    @file = File.expand_path(file)

    validate_file
  end

  def validate_file
    error('USAGE: ruby encrypt.rb|decrypt.rb FILEPATH') if blank?(file)

    error("#{file} is not exist") unless File.exist?(file)
    error("#{file} is directory (can not use)") if Dir.exist?(file)
  end

  def dirname
    @dirname ||= File.dirname(file)
  end

  def trash
    command = "rm -f #{file}"
    system(command)
  end

  def mac?
    host_os = RbConfig::CONFIG['host_os']
    host_os =~ /darwin|mac os/
  end
end
