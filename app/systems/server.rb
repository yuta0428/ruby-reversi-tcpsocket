# frozen_string_literal: true

require './app/models/player'
require './app/models/board'
require './app/controllers/board_controller'
require './app/systems/rocket'
require './app/systems/rocket_service'
require './app/systems/request'

# Server
class Server
  JOIN_MAX = App::COLOR_LIST.length

  def initialize
    board = Board.new(App::CELL_NUM)
    @controller = BoardController.new(board)
    @server = RocketBooster.new(20_000)
    @rocket_with_uuid = {}
    @player_list = []
  end

  def accept_end?
    @player_list.length >= JOIN_MAX
  end

  def main
    # Listen clients
    print 'Wait for connection...'
    Thread.new do
      until accept_end?
        sleep(1)
        print '.'
      end
    end
    until accept_end?
      # Wait connection
      rocket = @server.accept
      puts

      # Wait join request
      msg = rocket.wait
      req, = RocketService::RocketReceiver.to_struct(msg)

      # Create player data
      p = Player.new(req.name, App::COLOR_LIST[@player_list.length])
      @player_list.push(p)
      @rocket_with_uuid.store(p.id, rocket)

      # Return response to join player
      res = JoinResponse.new(player: p.to_obj)
      msg = RocketService::RocketSender.to_msg_res(res, 200)
      rocket.send(msg)
    end

    # Notify start game for all player
    @rocket_with_uuid.values.each do |rocket|
      req = GameStartNotify.new
      msg = RocketService::RocketSender.to_msg_req(req)
      rocket.send(msg)
    end

    ## wait my turn

    ## wait other turn

    # finish game
  end
end
