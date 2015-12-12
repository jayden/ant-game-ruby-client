require_relative './ant'

class Nest
  attr_reader :food_coordinates

  def initialize(team, client)
    @team = team
    @client = client
    register_self
  end

  def run
    initialize_colony
    while(true)
      step
      puts "\n\nNest #{id} has #{food} food in storage\n"
    end
  end

  def initialize_colony
    puts "Initializing colony"
    5.times do
      spawn
    end
  end

  def step
    issue_order{ |ant| ant.step }
  end

  def issue_order(&block)
    colony.each do |ant|
      yield ant
    end
  end

  def food
    stats.get_val(:stat, :food)
  rescue
    "UNKNOWN"
  end

  def spawn
    ant = @client.get("/#{id}/spawn")
    puts "Nest spawned ant: #{ant} total is #{colony.length}"
    colony << Ant.new(ant.get_val(:stat, :id), @client)
  end

  def ant_count
    colony.length
  end

  def colony
    @colony ||= []
  end

  def stats
    @client.get("/#{id}/stat")
  end

  private
  attr_writer :food_coordinates
  attr_accessor :team, :status

  def register_self
    self.status = @client.get("/join/#{team}")
  end

  def id
    status.get_val(:stat, :id)
  end
end
