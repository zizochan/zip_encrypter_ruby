require File.join(__dir__, 'file_converter')

class Decrypter < FileConverter
  attr_accessor :file, :password

  def initialize(file, with_trash: false, with_open_dir: true)
    super()

    set_password
    set_file(file)

    @with_trash = with_trash
    @with_open_dir = with_open_dir
  end

  def decrypt!
    file_decrypt
  end

  private

  def file_decrypt
    validate_not_zip_file

    error("unzip #{file} failed") unless to_unzip

    trash if @with_trash
    open_filedir_for_mac if @with_open_dir && mac?
  end

  def to_unzip
    command = "cd #{dirname} && unzip -qeP #{password} #{file}"
    system(command)
  end

  def open_filedir_for_mac
    command = "open #{dirname}"
    system(command)
  end

  def validate_not_zip_file
    error('not zip file can not be unzip') unless File.extname(file) == '.zip'
  end
end
