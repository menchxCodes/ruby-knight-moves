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

  def reset_board
    string = ' 12345678'
    @board.each_with_index do |row, row_index|
      row.each_with_index do |_col, col_index|
        @board[0][col_index] = string[col_index] if row_index.zero?

        @board[row_index][0] = row_index if col_index.zero?

        @board[row_index][col_index] = ' ' unless row_index.zero? || col_index.zero?
      end
    end
  end

  def knight_moves(start_point, end_point)
    reset_board
    knight = Knight.new
    board[start_point[0]][start_point[1]] = knight
    graph = build_graph(knight)
    reset_board
    step_path = navigate_graph(graph, [end_point[0], end_point[1]])
    puts "You made it in #{step_path[0]} moves!  Here's your path:"
    step_path[1].each_with_index do |path, index|
      p path
      set(index.to_s, path[0], path[1])
    end
    set(knight.avatar, start_point[0], start_point[1])
    print_board
  end

  def build_graph(piece, queue = [pos(piece)], result = 0)
    if queue.empty?
      # print_board
      return result
    end

    node = Node.find_node(queue.shift)

    set(piece, node.data[0], node.data[1]) unless pos(piece) == [node.data[0],node.data[1]]
    children = []
    valids = valid_moves(piece)
    valids.each do |move|
      queue.push(move)
      children.push(Node.find_node(move))
      children.each {|child| child.parent = node}
    end
    node.children = children
    node.parent = nil if result == 0

    remove(piece, 'x')
    result = node unless result != 0
    build_graph(piece, queue, result)
  end

  def navigate_graph(node, move, queue = [node], step = 1)
    return result if queue.empty?

    sub_queue = []
    until queue.empty?
      current_node = queue.shift
      if current_node.data == move
        path = []
        step.times do
          path.push(current_node.data)
          current_node = current_node.parent
        end
        return [step - 1, path.reverse]
      end
      current_node.children.each do |n|
        sub_queue.push(n)
      end
    end
    step += 1

    navigate_graph(node, move, sub_queue, step)
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
    remove(piece, 'x')
    set(piece, x, y)
    # print_board
    valid_moves(piece)
  end

  def move_legal(piece, x, y)
    valids = valid_moves(piece)
    if valids.include?([x,y])
      valids.each {|move| @board[move[0]][move[1]] = ' ' unless @board[move[0]][move[1]] == 'x' }
      move(piece, x, y)
      print_board
    elsif pos(piece) == [x, y]
      puts 'cannot move into itself'
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
      legal.push([x, y]) unless out_of_bounds || @board[x][y] == 'x'
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
  end

  def valid_moves
    valids = []
    [1, 2, -1, -2].permutation(2).each { |perm| valids.push(perm) unless perm[0].abs == perm[1].abs }
    valids
  end
end

class Node
  attr_accessor :children, :parent, :data
  attr_reader :nodes
  @@nodes = []
  def initialize(move)
    @data = move
    @children = []
    @parent = nil
    @@nodes.push(self)
  end

  def self.nodes
    @@nodes
  end

  def self.find_node(move)
    @@nodes.each do |node|
      if node.data == move
        return node
      end
    end
    Node.new(move)
  end

  def print_node
    puts "data #{self.data}"
    p "children #{self.children}"
  end
end
