# frozen_string_literal: true

require './app/models/board'
require './app/controllers/board_controller'
require './app/systems/rocket'
require './app/systems/rocket_service'
require './app/systems/request'

# Server
class Server
  def initialize
    board = Board.new(App::CELL_NUM)
    @controller = BoardController.new(board)
    @server = RocketBooster.new(20_000)
    @rocket_list = []
  end

  def accept_end?
    @rocket_list.length >= 2
  end

  def main
    # listen user
    print 'Wait for connection...'
    Thread.new do
      until accept_end?
        sleep(1)
        print '.'
      end
    end
    until accept_end?
      rocket = @server.accept
      @rocket_list.push(rocket)
      puts

      # connect and join request
      rocket.wait
      res = JoinResponse.new
      msg = RocketService::RocketSender.to_msg_res(res, 200)
      rocket.send(msg)
    end

    # start game

    ## wait my turn

    ## wait other turn

    # finish game
  end
end
