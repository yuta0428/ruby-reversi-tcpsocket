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

HEADER_JOIN = 'join'
JoinRequest = Struct.new('JoinRequest', :name, keyword_init: true)
JoinResponse = Struct.new('JoinResponse', keyword_init: true)

HEADER_PUT_PIECE = 'put_piece'
PutPieceRequest = Struct.new('PutPieceRequest', :input_type, :x, :y, :color, keyword_init: true)
PutPieceResponse = Struct.new('PutPieceResponse', :board, keyword_init: true)
