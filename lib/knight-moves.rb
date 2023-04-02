class Board
  attr_accessor :board

  def initialize
    string = ' abcdefgh'
    @board = Array.new(9) { Array.new(9) }
    @board.each_with_index do |row, row_index|
      row.each_with_index do |_col, col_index|
        board[0][col_index] = string[col_index] if col_index.zero?

        board[row_index][0] = row_index if col_index.zero?

        board[row_index][col_index] = ' ' unless row_index.zero? || col_index.zero?
      end
    end
  end

  def print_board
    puts "\n"
    @board.reverse.each_with_index do |row, _row_index|
      string = ''
      row.each_with_index do |col, _col_index|
        string.concat(" #{col} |")
      end
      puts string
      puts '------------------------------------'
    end
    puts "\n"
  end
end

#-- TESTS --
game_board = Board.new
# game_board.board[1][1] = "x"
# game_board.board[0][5] = 5
game_board.board[8][8] = 'x'
game_board.print_board

# game_board.print_board
