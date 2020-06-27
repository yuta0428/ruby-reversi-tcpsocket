# frozen_string_literal: true

# Abstract board cell
class Cell
  def initialize; end
end

# Wall board cell
class Wall < Cell
  def initialize; end
end

# Empty board cell
class Empty < Cell
  def initialize; end
end

# Piece board cell
class Piece < Cell
  WHITE = 0
  BLACK = 1

  attr_reader :color

  def initialize(color)
    @color = color
  end
end
