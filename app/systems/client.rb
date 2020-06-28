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
    puts "Success Join. Your color: #{@view.color2mark(@player.color)}"

    # Wait notify start game
    puts 'Wait GameStartNotify notify...'
    msg = @rocket.wait
    req, = RocketService::RocketReceiver.to_struct(msg)
    puts '======== [GAME START] ========'
    puts @view.render(req.board)

    # Main Game Loop
    loop do
      # Wait TurnStartNotify
      msg = @rocket.wait
      req, = RocketService::RocketReceiver.to_struct(msg)

      turn = req.turn
      is_myturn = req.is_myturn
      puts "======== [TURN:#{turn}] ========"
      if is_myturn
        loop do
          p 'Put cell (x y) >> '
          x, y = STDIN.gets.split.map!(&:to_i)

          if !x.nil? && !y.nil?
            # Crete PutPieceRequest
            req = PutPieceRequest.new(x: x, y: y, color: @player.color)
            msg = RocketService::RocketSender.to_msg_req(req)
            @rocket.send(msg)

            # Wait PutPieceResponse
            msg = @rocket.wait
            res, status = RocketService::RocketReceiver.to_struct(msg)
            break if res.is_ok
          end

          puts "Cant put (#{x},#{y}). Select other cell."
        end
      else
        puts 'Other player turn. Wait...'
      end

      # Wait TurnEndNotify
      is_finished = false
      loop do
        msg = @rocket.wait
        req, = RocketService::RocketReceiver.to_struct(msg)
        next unless req.class == TurnEndNotify

        is_finished = req.is_finished
        break
      end

      puts @view.render(req.board)
      break if is_finished
    end

    puts '======== [GAME FINISH] ========'

    # Wait GameFinishNotify
    msg = @rocket.wait
    req, = RocketService::RocketReceiver.to_struct(msg)
    puts '======== [RESULT] ========'
    req.results.each do |result|
      puts "#{result.player.name} #{@view.color2mark(result.player.color)}: #{result.cnt}."
    end

    winners = req.results
                 .max { |a, b| a.cnt <=> b.cnt }
                 .then { |max| req.results.select { |r| max.cnt == r.cnt } }
                 .to_a
    if winners.any? { |r| r.player.name == @player.name }
      puts '======== 🎉[YOU WIN!!]🎉 ========'
    else
      puts '======== [YOU LOSE] ========'
    end
  end
end
