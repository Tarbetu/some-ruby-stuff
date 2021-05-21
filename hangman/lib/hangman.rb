require_relative './saver_and_reloader'

class Box
  attr_reader :real_value

  def initialize(content)
    @shown = content == ' ' ? ' ' : '_'
    @real_value = content
  end

  def hidden?
    @shown == '_'
  end

  def to_s
    @shown
  end

  def try_to_reveal(char)
    char = char.downcase
    real_value = @real_value.downcase
    reveal_the_real_value! if char == real_value
  end

  private

  def reveal_the_real_value!
    @shown = @real_value
  end
end

class Board
  def initialize(secret_word)
    @board = create_board(secret_word)
  end

  def guess(char)
    before_trying = @board.to_s.freeze
    @board.each { |box| box.try_to_reveal char }
    before_trying != @board.to_s
  end

  def to_s
    @board.join(' ')
  end

  def show_hidden_values
    @board.map(&:real_value).join
  end

  def revealed?
    @board.none?(&:hidden?)
  end

  private

  def create_board(secret_word)
    board = secret_word.split('')

    board.map { |char| Box.new char }
  end
end

class WordSelector
  WORDS = File.read('dict.txt').split("\r\n").freeze

  def self.select_word
    word = WORDS[self.random_num]
    return word unless word.size < 5 || word.size > 12

    self.select_word
  end

  def self.random_num
    rand WORDS.size
  end
end

class Hangman
  def initialize
    game = load_board
    @board = game[0]
    @incorrect_guesses = game[1]
  end

  def trigger_the_game
    puts @board
    begin
      input_loop
    rescue
      save_the_game
      exit
    end
  end

  private

  def exit_if_win_or_lose
    if @board.revealed?
      Loader.remove_saves
      puts 'You have been survived!'
      exit
    end
    lose_exit if @incorrect_guesses.size > 5
  end

  def lose_exit
    puts 'You have been hanged!'
    puts "The word was \"#{@board.show_hidden_values}\""
    Loader.remove_saves
    exit
  end

  def input_loop
    loop do
      input = gets.chomp[0]
      guess = @board.guess input
      input = input.downcase
      @incorrect_guesses << input unless guess && @board.to_s.include?(input)

      @incorrect_guesses = @incorrect_guesses.uniq
      puts @board
      puts "Incorrect guesses: #{@incorrect_guesses.join(', ')}"
      puts "Your lives: #{6 - @incorrect_guesses.size}" unless @incorrect_guesses.size > 5
      exit_if_win_or_lose
    end
  end

  def save_the_game
    save = Saver.new @board, @incorrect_guesses
    save.save_status
  end

  def load_previous_game
    loader = Loader.new
    puts loader.message
    [loader.board, loader.incorrect_guesses]
  end

  def load_board
    if File.exist? '.saved'
      load_previous_game
    else
      puts 'This is classic hangman. Just guess the word! Press "Enter" without specifing any words to exit.'
      [Board.new(WordSelector.select_word), []]
    end
  end
end

game = Hangman.new
game.trigger_the_game
