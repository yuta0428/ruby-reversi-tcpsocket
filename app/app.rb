# frozen_string_literal: true

require './app/systems/server'
require './app/systems/client'

class App
  CELL_NUM = 4

  def main
    raise "Please add 'sever' or 'client' in arguments" if ARGV.empty?

    case ARGV[0]
    when 'server' then
      server = Server.new
      server.main
    when 'client' then
      client = Client.new
      client.main
    else
      raise 'wrong string of arguments'
    end
  end
end

App.new.main if __FILE__ == $PROGRAM_NAME
