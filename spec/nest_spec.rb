require 'rspec'
require_relative '../lib/nest.rb'
require_relative '../lib/response.rb'

describe Nest do
  let(:client) { double("client").as_null_object }
  let (:success) { Response.new(' {:response "ok", :stat {:type :nest :location [0 0] :food 5 :team "Braveheart" :id "1"}})') }
  let (:first_spawn_success) { Response.new(' {:response "ok", :stat {:type :ant :location [0 0] :got-food false :nest "1" :team "Braveheart" :n 1 :id "1"}})') }
  let (:second_spawn_success) { Response.new(' {:response "ok", :stat {:type :ant :location [0 0] :got-food false :nest "1" :team "Braveheart" :n 2 :id "2"}})') }
  let(:nest) { Nest.new("Braveheart", client) }

  describe "#initialize" do
    it "creates a nest" do
      expect(client).to receive(:get).with("/join/Braveheart").and_return(success)
      Nest.new("Braveheart", client)
    end
  end

  describe "#food_quantity" do
    it "returns the amount of food in storage" do
      allow(client).to receive(:get).and_return(success)

      expect(nest.food).to eq(5)
    end
  end

  describe "#spawn_ant" do
    it "requests an ant, and adds it to the colony" do
      nest_id = success.get_val(:stat, :id)
      allow(client).to receive(:get).with("/join/Braveheart").and_return(success)
      expect(client).to receive(:get).with("/#{nest_id}/spawn").and_return(first_spawn_success)

      expect(nest.ant_count).to eq(0)
      nest.spawn
      expect(nest.ant_count).to eq(1)
    end
  end
end
