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
    puts cell_info_list
      .map { |type| type2mark(type) }
      .each_slice(@len).to_a
      .map.with_index { |line, i| line.unshift(i.to_s.rjust(2)) }
      .unshift(['  '] + (0..@len - 1).map { |i| i.to_s.rjust(2) })
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

  def color2mark(color)
    case color
    when Piece::WHITE then WHITE.mark
    when Piece::BLACK then BLACK.mark
    end
  end
end
