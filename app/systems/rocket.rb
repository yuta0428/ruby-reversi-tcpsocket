# frozen_string_literal: true

require 'socket'

# rocket boost upper
class RocketBooster
  attr_reader :server
  def initialize(service)
    @server = TCPServer.open(service)
  end

  def accept
    Rocket.new(@server.accept)
  end

  def close
    @server.close
  end

  def self.connect_server(host, service)
    Rocket.new(TCPSocket.open(host, service))
  end
end

# socket wrapper with ruby
class Rocket
  attr_reader :socket
  def initialize(socket)
    @socket = socket
  end

  def close
    @socket.close
  end

  def send(payload)
    @socket.puts(payload)
  end

  def receive
    @socket.gets.chomp!
  end

  def wait
    t = receive while t.nil?
    t
  end
end
