require File.join(__dir__, 'file_converter')

class Encrypter < FileConverter
  attr_accessor :file, :password

  def initialize(file, force_password: nil)
    set_password(force_password: force_password)

    set_file(file)
  end

  def encrypt!
    file_encrypt
  end

  private

  def file_encrypt
    validate_zip_file
    validate_after_file

    unless to_zip
      error("zip #{file} failed")
    end

    trash
  end

  def before_filename
    @before_filename ||= File.basename(file)
  end

  def after_filename
    @after_filename ||= File.basename(file, '.*') + '.zip'
  end

  def validate_after_file
    after_filepath = File.join(dirname, after_filename)

    error("#{after_filepath} already exists") if File.exist?(after_filepath)
  end

  def to_zip
    command = "cd #{dirname} && zip -qeP #{password} #{after_filename} #{before_filename}"
    system(command)
  end

  def validate_zip_file
    error('zip file can not be zip') if File.extname(file) == '.zip'
  end
end
