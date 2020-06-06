# frozen_string_literal: true

require 'spec_helper'
require './app/systems/rocket'

describe Rocket do
  before(:all) do
    Thread.new do
      @server = RocketBooster.new(20_000)
    end

    # Allow server to start, so client doesn't send data
    # to the server before the server creates the socket.
    sleep 1
  end
  after(:all) do
    @server.close
  end
  before(:each) do
    @rocket_client = RocketBooster.connect_server('localhost', 20_000)
    @rocket_server = @server.accept
  end
  after(:each) do
    @rocket_client.close
    @rocket_server.close
  end

  it 'it valid send client to server' do
    @rocket_client.send('aaa')
    expect(@rocket_server.receive).to eq 'aaa'
  end

  it 'it valid send server to client' do
    @rocket_server.send('aaa')
    expect(@rocket_client.receive).to eq 'aaa'
  end

  it 'it valid send and receive' do
    @rocket_client.send('aaa')
    Thread.new do
      aaa = @rocket_server.receive
      @rocket_server.send(aaa + 'bbb')
    end
    receive = @rocket_client.wait
    expect(receive).to eq 'aaabbb'
  end
end
