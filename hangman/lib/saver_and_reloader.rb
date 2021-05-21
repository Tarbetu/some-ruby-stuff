require 'fileutils'

TARGET_DIR = '.saved'.freeze

class SaveContent
  def initialize(board, incorrect_guesses)
    @board = board
    @incorrect_guesses = incorrect_guesses
  end

  def obj
    {
      header: header,
      data: data
    }
  end

  private

  def header
    { save_time: Time.now }
  end

  def data
    {
      board: @board,
      incorrect_guesses: @incorrect_guesses
    }
  end
end

class Saver
  def initialize(board, incorrect_guesses)
    @data = SaveContent.new board, incorrect_guesses
  end

  def save_status
    build_directory
    save_time = Time.now.strftime '%d-%m-%Y~%H:%M:%S'
    filename = "#{TARGET_DIR}/hangman_#{save_time}.save"
    File.write(filename, serialized_data)
  end

  private

  def build_directory
    Loader.remove_saves
    Dir.mkdir TARGET_DIR
  end

  def serialized_data
    Marshal.dump @data
  end
end

class Loader
  def self.remove_saves
    FileUtils.remove_dir TARGET_DIR if File.exist? TARGET_DIR
  end

  def initialize
    save_file = File.read("#{TARGET_DIR}/#{Dir.entries(TARGET_DIR)[2]}")
    @data = Marshal.load save_file
  end

  def message
    saved_time = @data.obj[:header][:save_time]
    saved_time = saved_time.strftime '%d of %m in %Y, %H:%M'
    "The game from #{saved_time} has been reloaded! Enjoy!"
  end

  def board
    @data.obj[:data][:board]
  end

  def incorrect_guesses
    @data.obj[:data][:incorrect_guesses]
  end
end
