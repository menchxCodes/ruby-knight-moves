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

  def build_graph(piece, queue = [], result = [])
    node = queue.shift
    return result if queue.empty?
    valid_moves(piece).each do |move|
      node.children.push(move)
    end
    node.children.each { |child| queue.push(child) }
    
    puts "queue="
    p queue

    result.push(node)
    position = node.children[0]
    move_legal(piece, position[0], position[1])
    build_graph(piece, node, queue)

  end

  def set(piece, x, y)
    @board[x][y] = piece
  end

  def remove(piece, string = ' ')
    position = pos(piece)
    @board[position[0]][position[1]] = string
  end

  def pos(piece)
    @board.each_with_index do |row, index|
      position = row.find_index(piece)
      return [index, position] unless position.nil?
    end
  end

  def move(piece, x, y)
    remove(piece, "x")
    set(piece, x, y)
    # print_board
    valid_moves(piece)
  end

  def move_legal(piece,x, y)
    valids = valid_moves(piece)
    if valids.include?([x,y])
      valids.each {|move| @board[move[0]][move[1]] = ' ' unless @board[move[0]][move[1]] == "x" }
      move(piece,x,y)
      print_board
    else
      puts "invalid move #{x},#{y}"
    end
  end

  def valid_moves(piece)
    position = pos(piece)
    valids = piece.valid_moves
    legal = []
    valids.each do |move|
      x = position[0] + move[0]
      y = position[1] + move[1]
      out_of_bounds = (x > 8 || x < 1) || (y > 8 || y < 1)
      legal.push([x, y]) unless out_of_bounds || @board[x][y] == "x"
    end
    legal.each { |move| @board[move[0]][move[1]] = "\u2658" }
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

class Node
  attr_accessor :children

  def initialize(piece)
    @data = piece
    @children = []
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
# p game_board.valid_moves(knight)
# pp game_board.board[1..8][1..8]

# p game_board.pos(knight)
# game_board.move(knight,2,3)
# game_board.move(knight,4,4)

# game_board.move(knight,5,5)
# game_board.move(knight,4,7)

# game_board.move_legal(knight,6,1)
# game_board.move_legal(knight,8,1)
# game_board.move_legal(knight,8,2)
# game_board.move_legal(knight,6,3)

#--ARRAY LOOP
# valids = game_board.valid_moves(knight)
# until valids.empty?
#   sample = valids.sample
#   game_board.move_legal(knight,sample[0],sample[1])
#   valids = game_board.valid_moves(knight)
# end
game_board.build_graph(knight)