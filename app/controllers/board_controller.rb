# frozen_string_literal: true

# BoardController
class BoardController
  def initialize(board)
    @board = board
  end

  def get_cell_with_xy(x, y)
    @board.get_cell_with_xy(x, y)
  end

  def try_set_cell_with_xy!(x, y, value)
    return false unless @board.empty?(x, y)

    indexes = flip_pieces(x, y, value.color)
    return false if indexes.empty?

    @board.set_cell_with_xy!(x, y, value)
    @board.update!(value.color, indexes)
    true
  end

  def flip_pieces(x, y, color)
    indexes = []
    indexes += flip_cell_indexes_with_dir(x, y, color, 1, 0)  # right
    indexes += flip_cell_indexes_with_dir(x, y, color, -1, 0) # left
    indexes += flip_cell_indexes_with_dir(x, y, color, 0, -1) # up
    indexes += flip_cell_indexes_with_dir(x, y, color, 0, 1) # down
    indexes += flip_cell_indexes_with_dir(x, y, color, 1, -1)  # up_right
    indexes += flip_cell_indexes_with_dir(x, y, color, -1, -1) # up_left
    indexes += flip_cell_indexes_with_dir(x, y, color, 1, 1) # down_right
    indexes += flip_cell_indexes_with_dir(x, y, color, -1, 1) # down_left
    indexes
  end

  def flip_cell_indexes_with_dir(x, y, color, dir_x, dir_y)
    indexes = []
    loop do
      x += dir_x
      y += dir_y
      cell = get_cell_with_xy(x, y)
      return [] if cell.class != Piece
      return indexes if cell.color == color

      indexes << @board.xy2index(x, y)
    end
  end
end
