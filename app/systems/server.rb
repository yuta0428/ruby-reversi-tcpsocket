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

      # Wait JoinRequest
      msg = rocket.wait
      req, = RocketService::RocketReceiver.to_struct(msg)

      # Create player data
      p = Player.new(req.name, App::COLOR_LIST[@player_list.length])
      @player_list.push(p)
      @rocket_with_uuid.store(p.id, rocket)

      # Return JoinResponse to join player
      res = JoinResponse.new(player: p.to_obj)
      msg = RocketService::RocketSender.to_msg_res(res, 200)
      rocket.send(msg)
    end

    # GameStartNotify for all player
    @player_list.each do |player|
      rocket = @rocket_with_uuid[player.id]
      req = GameStartNotify.new(board: @controller.to_view)
      msg = RocketService::RocketSender.to_msg_req(req)
      rocket.send(msg)
    end

    # Main Game Loop
    turn = 0
    loop do
      turn_player_idx = turn % @player_list.length
      turn += 1

      # Send TurnStartNotify for al player
      turn_rocket = nil
      @player_list.each_with_index do |player, i|
        rocket = @rocket_with_uuid[player.id]
        is_myturn = turn_player_idx == i
        req = TurnStartNotify.new(turn: turn, is_myturn: is_myturn)
        msg = RocketService::RocketSender.to_msg_req(req)
        rocket.send(msg)

        turn_rocket = rocket if is_myturn
      end

      is_put = false
      until is_put
        # Wait player PutPieceRequest
        msg = turn_rocket.wait
        req, = RocketService::RocketReceiver.to_struct(msg)

        # Return PutPieceResponse
        is_put = @controller.try_set_cell_with_xy!(req.x, req.y, Piece.new(req.color))
        status = 200
        res = PutPieceResponse.new(is_ok: is_put)
        msg = RocketService::RocketSender.to_msg_res(res, status)
        turn_rocket.send(msg)
      end

      # Send TurnEndNotify for al player
      is_finished = @player_list.any? { |p| @controller.put_cell_any?(p.color) == false }
      @player_list.each_with_index do |player, _i|
        rocket = @rocket_with_uuid[player.id]
        req = TurnEndNotify.new(board: @controller.to_view, is_finished: is_finished)
        msg = RocketService::RocketSender.to_msg_req(req)
        rocket.send(msg)
      end

      break if is_finished
    end

    # GameFinishNotify for all player
    cnt_with_color = @controller.cnt_with_color
    results = @player_list
              .map(&:to_obj)
              .map { |p| ResultObj.new(p, cnt_with_color[p.color]) }
              .to_a
    @player_list.each do |player|
      rocket = @rocket_with_uuid[player.id]
      req = GameFinishNotify.new(turn: turn, results: results)
      msg = RocketService::RocketSender.to_msg_req(req)
      rocket.send(msg)
    end
  end
end
