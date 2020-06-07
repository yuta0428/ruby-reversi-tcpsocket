# frozen_string_literal: true

require './app/models/cell'

class App
  CELL_NUM = 4
  COLOR_LIST = [
    Piece::WHITE,
    Piece::BLACK
  ].freeze

  def main
    raise "Please add 'sever' or 'client' in arguments" if ARGV.empty?

    case ARGV[0]
    when 'server' then
      require './app/systems/server'
      server = Server.new
      server.main
    when 'client' then
      require './app/systems/client'
      client = Client.new
      client.main
    else
      raise 'wrong string of arguments'
    end
  end
end

App.new.main if __FILE__ == $PROGRAM_NAME
