class Board
  attr_accessor :board

  def initialize
    # string = ' abcdefgh'
    string = ' 12345678'
    @board = Array.new(9) { Array.new(9) }
    @board.each_with_index do |row, row_index|
      row.each_with_index do |_col, col_index|
        board[0][col_index] = string[col_index] if row_index.zero?

        board[row_index][0] = row_index if col_index.zero?

        board[row_index][col_index] = ' ' unless row_index.zero? || col_index.zero?
      end
    end
  end

  def pos(piece)
    @board.each_with_index do |row, index|
      position = row.find_index(piece)
      return [index, position] unless position.nil?
    end
  end

  def print_board
    puts "\n"
    @board.reverse.each_with_index do |row, _row_index|
      string = ''
      row.each_with_index do |col, _col_index|
        if col.instance_of?(Knight)
          string.concat(" #{col.avatar} |") if col.instance_of?(Knight)
        else
          string.concat(" #{col} |")
        end
      end
      puts string
      puts '------------------------------------'
    end
    puts "\n"
  end
end

class Knight
  attr_reader :avatar
  def initialize
    knight_utf = "\u265e"
    @avatar = "#{knight_utf.encode('utf-8')}"
    # @avatar = "K"
  end
end
#-- TESTS --
game_board = Board.new
# game_board.board[1][1] = "x"
# game_board.board[0][5] = 5


# game_board.print_board
knight = Knight.new
game_board.board[5][3] = knight
game_board.print_board
# pp game_board.board[1..8][1..8]
p game_board.pos(knight)