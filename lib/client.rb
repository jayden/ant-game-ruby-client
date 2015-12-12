require 'net/http'
require_relative './response'

class Client

  def initialize(host, port)
    self.client = Net::HTTP.new(host, port)
  end

  def get(path)
    response_body = client.get(path).body

    Response.new(response_body)
  end

  private
  attr_accessor :client
end
