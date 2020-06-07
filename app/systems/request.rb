# frozen_string_literal: true

def to_deep_hash(obj)
  if obj.is_a?(Struct)
    obj.to_h.each_with_object({}) do |(k, v), hash|
      hash[k] = to_deep_hash(v)
    end
  else
    obj
  end
end

Request = Struct.new('Request', :header, :param) do
  def to_hash
    to_deep_hash(self)
  end
end
Response = Struct.new('Response', :header, :body, :status) do
  def to_hash
    to_deep_hash(self)
  end
end

PlayerObj = Struct.new('PlayerObj', :id, :name, :color)

HEADER_JOIN = 'game/join'
JoinRequest = Struct.new('JoinRequest', :name, keyword_init: true)
JoinResponse = Struct.new('JoinResponse', :player, keyword_init: true) do
  def initialize(hash)
    super(player: PlayerObj.new(*hash[:player].values))
  end
end

HEADER_PUT_PIECE = 'put/piece'
PutPieceRequest = Struct.new('PutPieceRequest', :x, :y, :color, keyword_init: true)
PutPieceResponse = Struct.new('PutPieceResponse', :board, keyword_init: true)

HEADER_GAME_START = 'game/start'
GameStartNotify = Struct.new('GameStartNotify', keyword_init: true)

HEADER_TUEN_START = 'turn/start'
TurnStartNotify = Struct.new('TurnStartNotify', :turn, :is_myturn, keyword_init: true)

HEADER_GAME_FINISH = 'game/finish'
GameFinishNotify = Struct.new('GameFinishNotify', :turn, :winner_player, :result_num, keyword_init: true) do
  def initialize(hash)
    super(turn: turn, winner_player: PlayerObj.new(*hash[:winner_player].values), result_num: result_num)
  end
end
