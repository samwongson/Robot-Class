class BoxOfBolts < Item

  def initialize
    super("Box of bolts", 25)
  end

  def feed(robot)
    if robot.health <= 80
      robot.heal(20)
    else
      robot.heal(20)
    end
  end



end