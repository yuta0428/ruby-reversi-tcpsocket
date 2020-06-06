# frozen_string_literal: true

require './app/views/board_view'
require './app/systems/rocket'
require './app/systems/rocket_service'
require './app/systems/request'

# Client
class Client
  def initialize
    @view = BoardView.new(App::CELL_NUM)
    @rocket = nil
  end

  def main
    # join server
    print 'Your name >> '
    name = STDIN.gets.chomp!
    @rocket = RocketBooster.connect_server('localhost', 20_000)
    req = JoinRequest.new(name: name)
    msg = RocketService::RocketSender.to_msg_req(req)
    @rocket.send(msg)
    msg = @rocket.wait
    res, status = RocketService::RocketReceiver.to_struct(msg)
    # start game

    ## wait my turn

    ## wait other turn

    # finish game
  end
end
