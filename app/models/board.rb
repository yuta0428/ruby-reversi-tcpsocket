# frozen_string_literal: true

require './app/models/cell'

# Board
class Board
  # Constructor
  def initialize(len = 4)
    @pirce_len = len.freeze
    @board_len = (1 + @pirce_len + 1)
    @blocks = Array.new(@board_len * @board_len, Empty.new)

    ww = wall_indexes
    pp = center_indexes
    ww.each do |i|
      wall = Wall.new
      set_block_with_index!(i, wall)
    end
    pp.each do |i|
      color = i % 2
      piece = Piece.new(color)
      set_block_with_index!(i, piece)
    end
  end

  def update!
    # update board
  end

  def get_pieace_with_xy(x, y)
    get_block_with_index(xy2index(x, y))
  end

  def set_pieace_with_xy!(x, y, value)
    set_block_with_index!(xy2index(x, y), value)
  end

  def get_block_with_index(index)
    @blocks[index]
  end

  def set_block_with_index!(index, value)
    @blocks[index] = value
  end

  def xy2index(x, y)
    line = y * @board_len # 行
    row  = x # 列
    index = line + row # index
    raise "Smaller Length. index=#{index}" unless index >= 0
    raise "Bigger Length. index=#{index}" unless index < @board_len * @board_len

    index
  end

  def wall_indexes
    len = @board_len
    max = len * len
    w1 = [*(0..len)]
    w2 = [*0.step(max - len, len)]
    w3 = [*(len - 1).step(max - 1, len)]
    w4 = [*(max - len..max)]
    (w1 + w2 + w3 + w4).uniq
  end

  def center_indexes
    len = @pirce_len
    half_len = len / 2
    p1 = xy2index(half_len, half_len)
    p2 = p1 + 1
    p4 = xy2index(half_len + 1, half_len + 1)
    p3 = p4 - 1
    [p1, p2, p3, p4]
  end

  # def to_debug_print
  #   len = @board_len
  #   arr = (0..len * len - 1).each_slice(len).to_a
  #   arr.each do |a|
  #     puts a.map { |x| format('%02d', x) }.join(' ')
  #   end
  # end
end
