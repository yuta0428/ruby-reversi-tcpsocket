# frozen_string_literal: true

require 'spec_helper'
require './app/systems/request'
require './app/systems/rocket_service'

describe RocketService do
  context 'RocketSender' do
    it 'is valid to_msg_req' do
      context = JoinRequest.new(name: 'aaa')
      msg = '{"header":"join","param":{"name":"aaa"}}'
      expect(RocketService::RocketSender.to_msg_req(context)).to eq msg
    end

    it 'is valid to_msg_res' do
      context = JoinResponse.new(player: {})
      msg = '{"header":"join","body":{"player":{}},"status":200}'
      expect(RocketService::RocketSender.to_msg_res(context, 200)).to eq msg
    end
  end

  context 'RocketReceiver' do
    it 'is valid to_struct Request' do
      msg = '{"header":"join","param":{"name":"aaa"}}'
      hash = JoinRequest.new(name: 'aaa')
      expect(RocketService::RocketReceiver.to_struct(msg)).to eq [hash, nil]
    end

    it 'is valid to_struct Response' do
      msg = '{"header":"join","body":{"player":{}},"status":200}'
      hash = JoinResponse.new(player: {})
      expect(RocketService::RocketReceiver.to_struct(msg)).to eq [hash, 200]
    end
  end
end
