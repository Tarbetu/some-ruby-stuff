class Player
  attr_reader :player_name, :marking_style

  def initialize(player_name, marking_style = 'X')
    @player_name   = player_name
    @marking_style = marking_style
  end

  def prompt
    horizontal = get_input 'Horizontal'
    return nil unless prompt_valid? horizontal

    vertical = get_input 'Vertical'
    return nil unless prompt_valid? vertical

    [horizontal.to_i, vertical.to_i]
  end

  private

  def get_input(argue)
    print "#{@player_name} (#{@marking_style}) | #{argue}> "
    gets.chomp
  end

  def prompt_valid?(prompt)
    if (prompt == '0') || (prompt == '1') || (prompt == '2')
      true
    else
      puts 'Invalid entry'
      false
    end
  end
end

class Game
  def initialize(player1, player2)
    @board = Array.new(3) { Array.new(3) { '_' } }
    @player1 = player1
    @player2 = player2
  end

  def trigger_game
    turn = 0
    rewrite_screen
    puts how_to_play
    loop do
      player = turn.even? ? @player1 : @player2
      player == @player1 ? rewrite_screen : print_board
      answer = get_player_answer(player)
      next if answer.nil?

      declare_the_winner_and_exit(player) if someone_win?

      turn += 1
    end
  end

  private

  def how_to_play
    "This is a simply Tic-Tac-Toe.
    You should match row, columns with your sign. \
    Also you can match the crosses.

    You may sign with indicate coordinates ← horizontally → and ↑ vertically ↓
     


    "
  end

  def get_player_answer(player)
    player_answer = player.prompt
    return nil if player_answer.nil?

    mark_a_place(player, player_answer)
  end

  def declare_the_winner_and_exit(player)
    puts "#{player.player_name} (#{player.marking_style}) wins the game!"
    exit
  end

  def mark_a_place(player, answer)
    if place_empty? answer[0], answer[1]
      mark_place player, answer[0], answer[1]
    else
      puts 'This place is not empty!'
    end
  end

  def someone_win?
    @board.reject { |row| row == %w[_ _ _] }.each do |row|
      return true if (row[0] == row[1]) && (row[1] == row[2])
    end

    3.times do |column|
      winning_columns = (@board[0][column] == @board[1][column]) && (@board[2][column] == @board[1][column])
      return true if winning_columns && (@board[0][column] != '_')
    end

    first_condition_for_cross_winning  = (@board[0][0] == @board[1][1]) && (@board[1][1] == @board[2][2])
    second_condition_for_cross_winning = (@board[2][0] == @board[1][1]) && (@board[1][1] == @board[0][2])
    if (first_condition_for_cross_winning || second_condition_for_cross_winning) && (@board[1][1] != '_')
      return true
    end

    false
  end

  def mark_place(player, x_cor, y_cor)
    @board[y_cor][x_cor] = player.marking_style
  end

  def place_empty?(x_cor, y_cor)
    @board[y_cor][x_cor] == '_'
  end

  def rewrite_screen
    puts Gem.win_platform? ? `cls` : `clear`
    print_board
  end

  def print_board
    puts 'horizon'
    puts '0  1  2 '
    @board.each_with_index do |sq, ind|
      puts "#{sq.join '  '} #{ind} | #{"VER"[ind]}\n"
    end
  end
end

begin
  puts 'Write name for X'
  player_x = Player.new gets.chomp
  puts 'Write name for O'
  player_o = Player.new gets.chomp, 'O'
  game = Game.new player_x, player_o
  game.trigger_game
rescue Interrupt
  exit
end
