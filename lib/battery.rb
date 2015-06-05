class Battery < Item

  CHARGE_AMOUNT = 25
  def initialize
    super("Battery", 25)    
  end

  def charge(robot)
    robot.eat_battery
  end
  
  
end