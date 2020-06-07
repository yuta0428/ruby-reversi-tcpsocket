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

    # Notify game start for all player
    @player_list.each do |player|
      rocket = @rocket_with_uuid[player.id]
      req = GameStartNotify.new
      msg = RocketService::RocketSender.to_msg_req(req)
      rocket.send(msg)
    end

    # Main Game Loop
    turn = 0
    is_finished = false
    winner_player = nil
    unless is_finished
      turn_player_idx = turn % player_list.length
      turn += 1

      ## Notify turn tart for al player
      @player_list.each_with_index do |player, i|
        rocket = @rocket_with_uuid[player.id]
        is_myturn = turn_player_idx == i
        req = TurnStartNotify.new(turn, is_myturn)
        msg = RocketService::RocketSender.to_msg_req(req)
        rocket.send(msg)
      end

      is_put = false
      unless is_put
        # Wait player put piece
        msg = rocket.wait
        req, = RocketService::RocketReceiver.to_struct(msg)

        # Return put result
        is_put = @controller.try_set_cell_with_xy!(req.x, req.y, Piece.new(req.color))
        status = is_put ? 200 : 900
        res = PutPieceResponse.new(board: @controller.to_view)
        msg = RocketService::RocketSender.to_msg_res(res, status)
        rocket.send(msg)
      end

      # Check finish game
      @player_list.each do |player|
        is_finished = @controller.put_cell_any?(player.color)
        winner_player = player if is_finished
      end
    end

    # Notify game finish for all player
    @player_list.each do |player|
      rocket = @rocket_with_uuid[player.id]
      cnt_with_color = @controller.cnt_with_color
      req = GameFinishNotify.new(turn: turn, winner_player: winner_player.to_obj, result_num: cnt_with_color)
      msg = RocketService::RocketSender.to_msg_req(req)
      rocket.send(msg)
    end
  end
end
