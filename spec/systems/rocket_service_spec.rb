# frozen_string_literal: true

require 'spec_helper'
require './app/systems/request'
require './app/systems/rocket_service'

describe RocketService do
  let(:req) do
    msg = RocketService::RocketSender.to_msg_req(request)
    req, = RocketService::RocketReceiver.to_struct(msg)
    req
  end
  let(:res) do
    msg = RocketService::RocketSender.to_msg_res(response, 200)
    res, = RocketService::RocketReceiver.to_struct(msg)
    res
  end

  context 'when JoinRequest' do
    let(:request) { JoinRequest.new(name: 'aaa') }
    it { expect(req).to eq request }
  end
  context 'when JoinResponse' do
    player = PlayerObj.new(4_122_914_363, 'aaaa', 1)
    let(:response) { JoinResponse.new(player: player) }
    it { expect(res).to eq response }
  end

  context 'when PutPieceRequest' do
    let(:request) { PutPieceRequest.new(x: 1, y: 1, color: 0) }
    it { expect(req).to eq request }
  end
  context 'when PutPieceResponse' do
    let(:response) { PutPieceResponse.new(is_ok: true) }
    it { expect(res).to eq response }
  end

  context 'when GameStartNotify' do
    let(:request) { GameStartNotify.new(board: [0, 1, 2]) }
    it { expect(req).to eq request }
  end

  context 'when TurnStartNotify' do
    let(:request) { TurnStartNotify.new(turn: 1, is_myturn: true) }
    it { expect(req).to eq request }
  end

  context 'when TurnEndNotify' do
    let(:request) { TurnEndNotify.new(board: [0, 1, 2], is_finished: false) }
    it { expect(req).to eq request }
  end

  context 'when GameFinishNotify' do
    results = (0..3)
              .map { |i| PlayerObj.new(i, 'aaaa', 1) }
              .map { |p| ResultObj.new(p, 10) }
              .to_a
    let(:request) { GameFinishNotify.new(turn: 1, results: results) }
    it { expect(req).to eq request }
  end
end
