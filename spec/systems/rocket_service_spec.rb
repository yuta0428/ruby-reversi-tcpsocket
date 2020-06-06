# frozen_string_literal: true

require 'spec_helper'
require './app/systems/request'
require './app/systems/rocket_service'

describe RocketService do
  # (req, res) x (sender, receiver)
  describe 'Request' do
    let(:hash) { RocketService::RocketSender._wrap_for_request(param) }
    let(:struct) { RocketService::RocketReceiver._unwrap_for_request(req)[0] }

    context 'JoinRequest' do
      let(:param) { JoinRequest.new(name: 'aaa') }
      it 'is valid sender' do
        expect(hash[:header]).to eq HEADER_JOIN
        expect(hash[:param][:name]).to eq 'aaa'
      end
      let(:req) { Request.new(HEADER_JOIN, param: { name: 'bbb' }) }
      it 'is valid receiver' do
        expect(struct.name).to eq 'bbb'
      end
    end
  end

  describe 'Response' do
    let(:hash) { RocketService::RocketSender._wrap_for_response(body, 200) }
    let(:arr) { RocketService::RocketReceiver._unwrap_for_response(res) }
    context 'JoinResponse' do
      let(:body) { JoinResponse.new }
      it 'is valid sender' do
        expect(hash[:header]).to eq HEADER_JOIN
        expect(hash[:status]).to eq 200
        expect(hash[:body].values).to be_empty
      end
      let(:res) { Response.new(HEADER_JOIN, { body: {} }, 200) }
      it 'is valid receiver' do
        expect(arr[1]).to eq 200
        expect(arr[0].values).to be_empty
      end
    end
  end
end
