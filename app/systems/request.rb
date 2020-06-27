# frozen_string_literal: true

def to_deep_hash(obj)
  if obj.is_a?(Struct)
    obj.to_h.each_with_object({}) do |(k, v), hash|
      hash[k] = to_deep_hash(v)
    end
  elsif obj.is_a?(Array)
    obj.map { |o| to_deep_hash(o) }.to_a
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

ResultObj = Struct.new('ResultObj', :player, :cnt)

HEADER_JOIN = 'game/join'
JoinRequest = Struct.new('JoinRequest', :name, keyword_init: true)
JoinResponse = Struct.new('JoinResponse', :player, keyword_init: true) do
  def initialize(hash)
    super(player: PlayerObj.new(*hash[:player].values))
  end
end

HEADER_PUT_PIECE = 'put/piece'
PutPieceRequest = Struct.new('PutPieceRequest', :x, :y, :color, keyword_init: true)
PutPieceResponse = Struct.new('PutPieceResponse', :is_ok, keyword_init: true)

HEADER_GAME_START = 'game/start'
GameStartNotify = Struct.new('GameStartNotify', :board, keyword_init: true)

HEADER_TUEN_START = 'turn/start'
TurnStartNotify = Struct.new('TurnStartNotify', :turn, :is_myturn, keyword_init: true)

HEADER_TUEN_END = 'turn/end'
TurnEndNotify = Struct.new('TurnEndNotify', :board, :is_finished, keyword_init: true)

HEADER_GAME_FINISH = 'game/finish'
GameFinishNotify = Struct.new('GameFinishNotify', :turn, :results, keyword_init: true) do
  def initialize(hash)
    super(
      turn: hash[:turn],
      results: hash[:results]
        .map { |r| ResultObj.new(PlayerObj.new(*r[:player].values), r[:cnt]) }
        .to_a
    )
  end
end
