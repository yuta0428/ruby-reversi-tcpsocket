# frozen_string_literal: true

# Abstract board cell
class Block
  BLOCK_TYPE_WALL = 1
  BLOCK_TYPE_EMPTY = 2
  BLOCK_TYPE_PIECE = 3

  def state
    raise NotImplementedError, "#{self.class}##{__method__} が実装されていません"
  end
end

# Wall board cell
class Wall < Block
  def initialize; end

  def state
    BLOCK_TYPE_WALL
  end
end

# Empty board cell
class Empty < Block
  def initialize; end

  def state
    BLOCK_TYPE_EMPTY
  end
end

# Piece board cell
class Piece < Block
  WHITE = 0
  BLACK = 1

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def state
    BLOCK_TYPE_PIECE
  end
end
