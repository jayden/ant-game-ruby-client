class Ant
  HOME_X, HOME_Y = 0,0
  attr_reader :id, :x, :y

  def initialize(id, client)
    @id = id
    @x, @y = HOME_X, HOME_Y
    @client = client
  end

  def go_fetch(x, y)
    set_poi(x,y) unless has_food?
  end

  def poi
    (poi_x && poi_y) ? [poi_x, poi_y] : nil
  end

  def step
    if poi
      move_towards_poi
    else
      random_move
    end

    if has_food?
      set_poi(HOME_X, HOME_Y)
      puts "Ant #{id} found food at #{self.x}, #{self.y}!"
    end
  end

  private
  attr_accessor :client, :poi_x, :poi_y, :status
  attr_writer :x, :y

  def has_food?
   if status
     status.get_val(:stat, :"got-food")
   else
     false
   end
  end

  def set_poi(x, y)
    self.poi_x = x
    self.poi_y = y
  end

  def update_coords
    coords = status.get_val(:stat, :location)
    self.x = coords[0]
    self.y = coords[1]
    puts "Ant #{id} is now at #{self.x}, #{self.y}"
  rescue
    puts "Failed to update coordinates for ant #{id}"
    #no-op
  end

  def move_towards_poi
    move_west if @x > poi_x
    move_east if @x < poi_x
    move_north if @y > poi_y
    move_south if @y < poi_y

    set_poi(nil, nil) if (@x == poi_x && @y == poi_y && !has_food?)
  end

  def random_move
    self.send([
      :move_north,
      :move_east,
      :move_south,
      :move_west,
      :move_north_east,
      :move_north_west,
      :move_south_east,
      :move_south_west
    ].sample)
  end

  def move_north
    move("n")
  end

  def move_east
    move("e")
  end

  def move_south
    move("s")
  end

  def move_west
    move("w")
  end

  def move_north_east
    move("ne")
  end

  def move_north_west
    move("nw")
  end

  def move_south_east
    move("se")
  end

  def move_south_west
    move("sw")
  end

  def move(direction)
    self.status = client.get("/#{id}/go/#{direction}")
    update_coords
  end
end
