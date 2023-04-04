require_relative "./lib/knight-moves.rb"

game_board = Board.new
# -- You can edit the code below to try out different moves

game_board.knight_moves([3, 3], [4, 3])
game_board.knight_moves([5, 3], [8, 8])
game_board.knight_moves([5, 3], [5, 2])
