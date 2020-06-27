# frozen_string_literal: true

require './app/systems/request'
require './app/systems/parser'

module RocketService
  class << self
    # hash to string
    def serialize(hash)
      Parser::JsonParser.serialize(hash)
    end

    # string to hash
    def deserialize(payload)
      Parser::JsonParser.deserialize(payload)
    end
  end

  # message sender
  class RocketSender
    def self.to_msg_req(context)
      req = _wrap_for_request(context)
      RocketService.serialize(req.to_hash)
    end

    def self.to_msg_res(context, status)
      res = _wrap_for_response(context, status)
      RocketService.serialize(res.to_hash)
    end

    # send to request
    def self._wrap_for_request(param)
      req =
        case param
        when JoinRequest then Request.new(HEADER_JOIN, param)
        when PutPieceRequest then Request.new(HEADER_PUT_PIECE, param)
        when GameStartNotify then Request.new(HEADER_GAME_START, param)
        when TurnStartNotify then Request.new(HEADER_TUEN_START, param)
        when TurnEndNotify then Request.new(HEADER_TUEN_END, param)
        when GameFinishNotify then Request.new(HEADER_GAME_FINISH, param)
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
    def self.to_struct(msg)
      hash = RocketService.deserialize(msg)
      if hash.key?(:status) then _unwrap_for_response(Response.new(*hash.values))
      else _unwrap_for_request(Request.new(*hash.values))
      end
    end

    # receive to request
    def self._unwrap_for_request(req)
      param =
        case req.header
        when HEADER_JOIN then JoinRequest.new(req.param)
        when HEADER_PUT_PIECE then PutPieceRequest.new(req.param)
        when HEADER_GAME_START then GameStartNotify.new(req.param)
        when HEADER_TUEN_START then TurnStartNotify.new(req.param)
        when HEADER_TUEN_END then TurnEndNotify.new(req.param)
        when HEADER_GAME_FINISH then GameFinishNotify.new(req.param)
        end
      [param, nil]
    end

    # receive to response
    def self._unwrap_for_response(res)
      body =
        case res.header
        when HEADER_JOIN then JoinResponse.new(res.body)
        when HEADER_PUT_PIECE then PutPieceResponse.new(res.body)
        end
      [body, res.status]
    end
  end
end
