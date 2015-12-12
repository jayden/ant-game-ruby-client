require 'rspec'
require_relative '../lib/ant.rb'
require_relative '../lib/response.rb'

describe Ant do
  let (:client) { double("client") }
  let (:got_food)   { Response.new('{:response "ok", :stat {:type :ant, :location [-5 0], :got-food true, :team "Braveheart", :n 1, :id "123" }}') }
  let (:failure) { Response.new("Are you lost little ant?") }
  let (:id) { 123 }
  let (:ant) { Ant.new(id, client) }

  describe "#go_fetch" do
    it "sets the active point of interest for this ant" do
      ant.go_fetch(0,2)
      expect(client).to receive(:get).with("/#{id}/go/s")
      ant.step
      expect(client).to receive(:get).with("/#{id}/go/s")
      ant.step
    end
  end

  describe "#step" do
    it "goes back home if it has food" do
      ant.go_fetch(5,0)

      allow(client).to receive(:get).and_return(got_food)
      ant.step

      expect(ant.poi).to eq [0,0]
    end
  end
end
