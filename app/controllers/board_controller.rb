# frozen_string_literal: true

# BoardController
class BoardController
  def initialize
    @board = nil
  end

  def register_board(board)
    @board = board
  end

  def get_cell_with_xy(x, y)
    @board.get_cell_with_xy(x, y)
  end

  def try_set_cell_with_xy!(x, y, value)
    block = @board.get_cell_with_xy(x, y)
    return false if block.class != Empty

    @board.set_cell_with_xy!(x, y, value)
    true
  end
end
