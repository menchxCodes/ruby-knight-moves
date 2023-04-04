require_relative "./lib/knight-moves.rb"

game_board = Board.new
game_board.knight_moves([3, 3], [4, 3])
game_board.knight_moves([5, 3], [8, 8])
game_board.knight_moves([5, 3], [5, 2])