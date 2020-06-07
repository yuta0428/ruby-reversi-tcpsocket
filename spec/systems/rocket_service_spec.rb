# frozen_string_literal: true

require 'spec_helper'
require './app/systems/request'
require './app/systems/rocket_service'

describe RocketService do
  context 'Request' do
    let(:request) { JoinRequest.new(name: 'aaa') }
    let(:msg) { '{"header":"game/join","param":{"name":"aaa"}}' }

    it 'is valid RocketSender.to_msg_req' do
      expect(RocketService::RocketSender.to_msg_req(request)).to eq msg
    end

    it 'is valid RocketReceiver.to_struct' do
      expect(RocketService::RocketReceiver.to_struct(msg)).to eq [request, nil]
    end
  end

  context 'Response' do
    let(:response) { JoinResponse.new(player: PlayerObj.new(4_122_914_363, 'aaaa', 1)) }
    let(:msg) { '{"header":"game/join","body":{"player":{"id":4122914363,"name":"aaaa","color":1}},"status":200}' }

    it 'is valid RocketSender.to_msg_res' do
      expect(RocketService::RocketSender.to_msg_res(response, 200)).to eq msg
    end

    it 'is valid to_struct Request' do
      expect(RocketService::RocketReceiver.to_struct(msg)).to eq [response, 200]
    end
  end
end
