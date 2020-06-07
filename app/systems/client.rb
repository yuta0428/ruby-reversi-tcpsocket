# frozen_string_literal: true

require './app/models/player'
require './app/views/board_view'
require './app/systems/rocket'
require './app/systems/rocket_service'
require './app/systems/request'

# Client
class Client
  def initialize
    @view = BoardView.new(App::CELL_NUM)
    @rocket = nil
    @player = nil
  end

  def main
    # Connect server
    print 'Your name >> '
    name = STDIN.gets.chomp!
    @rocket = RocketBooster.connect_server('localhost', 20_000)

    # Crete join request
    req = JoinRequest.new(name: name)
    msg = RocketService::RocketSender.to_msg_req(req)
    @rocket.send(msg)

    # Wait join response
    msg = @rocket.wait
    res, status = RocketService::RocketReceiver.to_struct(msg)
    if status != 200
      puts 'Faild Join.'
      exit
    end

    # Create player data
    @player = Player.new(res.player.name, res.player.color)
    puts "Success Join. Your color: #{@player.color}"

    # Wait notify start game
    puts 'Wait game start notify...'
    @rocket.wait

    puts '======== [GAME START] ========'

    ## wait my turn

    ## wait other turn

    # finish game
  end
end
