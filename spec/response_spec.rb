require 'rspec'
require_relative '../lib/response.rb'

describe Response do
  describe "#get_val" do
    it "gets the value of the node" do
      response_body = '{:response "ok", :stat {:type :ant}}'
      data = Response.new(response_body)

      expect(data.get_val(:stat, :type)).to eq(:ant)
    end
  end
end
