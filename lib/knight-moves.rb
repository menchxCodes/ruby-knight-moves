class Board
  attr_accessor :board

  def initialize
    # string = ' abcdefgh'
    string = ' 12345678'
    @board = Array.new(9) { Array.new(9) }
    @board.each_with_index do |row, row_index|
      row.each_with_index do |_col, col_index|
        @board[0][col_index] = string[col_index] if row_index.zero?

        @board[row_index][0] = row_index if col_index.zero?

        @board[row_index][col_index] = ' ' unless row_index.zero? || col_index.zero?
      end
    end
  end

  def set(piece, x, y)
    @board[x][y] = piece
  end

  def remove(piece)
    position = pos(piece)
    @board[position[0]][position[1]] = ' '
  end

  def pos(piece)
    @board.each_with_index do |row, index|
      position = row.find_index(piece)
      return [index, position] unless position.nil?
    end
  end

  def move(piece, x, y)
    remove(piece)
    set(piece, x, y)
    print_board
  end

  def valid_moves(piece)
    position = pos(piece)
    valids = piece.valid_moves
    legal = []
    valids.each do |move|
      x = position[0] + move[0]
      y = position[1] + move[1]
      out_of_bounds = (x > 8 || x < 1) || (y > 8 || y < 1)
      legal.push([x, y]) unless out_of_bounds
    end
    legal.each { |move| @board[move[0]][move[1]] = "\u2658" }
    print_board
    legal
  end

  def print_board
    puts "\n"
    @board.reverse.each_with_index do |row, _row_index|
      string = ''
      row.each_with_index do |col, _col_index|
        col.instance_of?(Knight) ? string.concat(" #{col.avatar} |") : string.concat(" #{col} |")
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
    @avatar = knight_utf.encode('utf-8')
    # @avatar = "K"
  end

  def valid_moves
    valids = []
    [1,2,-1,-2].permutation(2).each {|perm| valids.push(perm) unless perm[0].abs == perm[1].abs}
    valids
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
game_board.move(knight,2,3)
game_board.move(knight,4,4)
# p knight.valid_moves
# p game_board.valid_moves(knight)

game_board.move(knight,7,2)
p game_board.valid_moves(knight)