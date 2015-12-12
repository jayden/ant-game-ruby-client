require 'edn'

class Response

  def initialize(response_body)
    self.response_body = response_body
  end

  def get_val(*nodes)
    data = EDN.read(response_body)

    nodes.each do |node|
      data = data[node]
    end

    data
  rescue
    nil
  end

  private

  attr_accessor :response_body
end
