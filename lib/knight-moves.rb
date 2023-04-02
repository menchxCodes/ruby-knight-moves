class Board
  attr_accessor :board
  def initialize
    string = " abcdefgh"
    @board = Array.new(9,' ') { Array.new(9,' ') }
    @board.each_with_index do |row,row_index|
      row.each_with_index do |col,col_index|
        if row_index == 0
          board[0][col_index] = string[col_index]
        end

        if col_index == 0
          board[row_index][0] = row_index
        end
      end
    end
  end

  def print_board
    @board.reverse.each_with_index do |row,row_index|
      string = ''
      row.each_with_index do |col,col_index|
        string.concat(" #{col.to_s} |")
      end
      puts string
      puts "------------------------------------"
    end
  end
  
end

#-- TESTS --
game_board = Board.new
# game_board.board[1][1] = "x"
# game_board.board[0][5] = 5
game_board.board[8][8] = "x"
game_board.print_board

# game_board.print_board
