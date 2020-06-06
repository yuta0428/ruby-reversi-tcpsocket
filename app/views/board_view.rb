# frozen_string_literal: true

class CellView < Struct.new(:type, :mark)
end

class BoardView
  WALL  = CellView.new(-1, '⬜').freeze
  EMPTY = CellView.new(0,  '  ').freeze
  WHITE = CellView.new(1,  '⚪').freeze
  BLACK = CellView.new(2,  '⚫').freeze

  def initialize(pirce_len)
    @len = 1 + pirce_len + 1
  end

  def render(cell_info_list)
    cell_info_list
      .map { |type| type2mark(type) }
      .each_slice(@len).to_a
      .map(&:join)
      .join("\n")
  end

  def type2mark(type)
    case type
    when WALL.type  then WALL.mark
    when EMPTY.type then EMPTY.mark
    when WHITE.type then WHITE.mark
    when BLACK.type then BLACK.mark
    else '  '
    end
  end
end
