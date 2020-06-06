# frozen_string_literal: true

Request = Struct.new('Request', :header, :param)
Response = Struct.new('Response', :header, :body, :status)

HEADER_JOIN = 'join'
JoinRequest = Struct.new('JoinRequest', :name, keyword_init: true)
JoinResponse = Struct.new('JoinResponse', keyword_init: true)

HEADER_PUT_PIECE = 'put_piece'
PutPieceRequest = Struct.new('PutPieceRequest', :input_type, :x, :y, :color, keyword_init: true)
PutPieceResponse = Struct.new('PutPieceResponse', :board, keyword_init: true)
