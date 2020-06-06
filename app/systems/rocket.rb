# frozen_string_literal: true

require 'socket'

# rocket boost upper
class RocketBooster
  attr_reader :server
  def initialize(service)
    @server = TCPServer.open(service)
  end

  def accept
    Rocket.new(@server.accept, true)
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
  def initialize(socket, is_vervose = false)
    @socket = socket
    @is_vervose = is_vervose
  end

  def close
    @socket.close
  end

  def send(payload)
    puts '[SEND]' + payload if @is_vervose
    @socket.puts(payload)
  end

  def receive
    msg = @socket.gets.chomp!
    puts '[RECV]' + msg if @is_vervose
    msg
  end

  def wait
    t = receive while t.nil?
    t
  end
end
