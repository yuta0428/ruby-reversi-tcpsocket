# frozen_string_literal: true

require 'securerandom'

class Player
  attr_reader :id, :name, :color

  def initialize(name, color)
    @id = SecureRandom.random_number(1 << 32)
    @name = name
    @color = color
  end

  def to_obj
    PlayerObj.new(id, name, color)
  end
end
