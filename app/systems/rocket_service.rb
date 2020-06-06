# frozen_string_literal: true

require './app/systems/request'
require './app/systems/parser'

module RocketService
  # hash to string
  def serialize(hash)
    Parser::JsonParser.serialize(hash)
  end

  # string to hash
  def deserialize(payload)
    Parser::JsonParser.deserialize(payload)
  end

  # message sender
  class RocketSender
    def self.wrap(context, status = nil)
      if status.nil? then _wrap_for_request(context)
      else _wrap_for_response(context, status)
      end
  end

    # send to request
    def self._wrap_for_request(param)
      req =
        case param
        when JoinRequest then Request.new(HEADER_JOIN, param)
        when PutPieceRequest then Request.new(HEADER_PUT_PIECE, param)
        end
      req
    end

    # send to response
    def self._wrap_for_response(body, status)
      res =
        case body
        when JoinResponse then Response.new(HEADER_JOIN, body, status)
        when PutPieceResponse then Response.new(HEADER_PUT_PIECE, body, status)
        end
      res
    end
  end

  # message receiver
  class RocketReceiver
    def self.unwrap(hash)
      if hash.key?(:status) then _unwrap_for_response(Responce.new(*hash.values))
      else _unwrap_for_request(Request.new(*hash.values))
      end
    end

    # receive to request
    def self._unwrap_for_request(req)
      param =
        case req.header
        when HEADER_JOIN then JoinRequest.new(*req.param.values)
        when HEADER_PUT_PIECE then PutPieceRequest.new(*req.param.values)
        end
      [param, nil]
    end

    # receive to response
    def self._unwrap_for_response(res)
      body =
        case res.header
        when HEADER_JOIN then JoinResponse.new
        when HEADER_PUT_PIECE then PutPieceResponse.new(*res.body.values)
        end
      [body, res.status]
    end
  end
end
