class CannotHealWhileDeadError < StandardError
end

class InvalidTargetError < StandardError
end

class Robot
  MAX_SHIELD = 50

  @@all_bots = []
  attr_reader :position, :items, :health, :max_health, :shield
  attr_accessor :equipped_weapon

  def initialize
    @position = [0,0]
    @items = []
    @health = 100
    @max_health = 100
    @equipped_weapon = nil
    @shield = 50
  end

  def self.list
    @@all_bots
  end 

  def self.all_locations
    @@all_bots.collect {|robot| robot.position}
  end

  def self.in_position(x, y)
    @@all_bots.select {|robot| robot.position == [x,y]}
  end


  def scan
    x = position[0]
    y = position[1]
    hits = []
    hits << Robot.in_position(x+1, y) #square to the right
    hits << Robot.in_position(x-1, y) #square to the left
    hits << Robot.in_position(x, y+1) #square above
    hits << Robot.in_position(x, y-1)
    hits #square below

  end

  def self.create
    bot = Robot.new
    @@all_bots << bot
    bot

  end


  def move_left
    @position[0] -= 1
  end

  def move_right
    @position[0] += 1
  end

  def move_up
    @position[1] += 1
  end

  def move_down
    @position[1] -= 1
  end

  def pick_up(item)
    if item.weight + self.items_weight > 250
      false
    else
      if item.is_a?(Weapon)
        @equipped_weapon = item
      elsif item.is_a?(BoxOfBolts) && health <= 80
        item.feed(self)

      else
        @items << item
      end
    end

  end

  def items_weight
    @items.inject(0) {|total, item| total + item.weight}
  end

  def wound(damage)
    
    if damage > (@health + @shield)
      @health -= @health
    elsif damage > @shield
      @health -= (@shield - damage).abs
      @shield = 0
    elsif damage < @shield
      @shield -= damage
    end
  end

  def heal(heal_amt)
    if (heal_amt + @health) > @max_health
      @health = 100
    else
      @health += heal_amt
    end
  end

  def heal!(heal_amt)
    if @health == 0
      raise CannotHealWhileDeadError, "You're already dead!"
    else
      heal(heal_amt)
    end
  end

  def attack(target)
    if self.equipped_weapon.nil? 
      if target.position[0].abs - self.position[0].abs <= 1 && target.position[1].abs - self.position[1].abs <= 1
        target.wound(5)
      end

    elsif self.in_range?(target) 
    
      if @equipped_weapon.is_a?(Grenade)
        @equipped_weapon.hit(target)
        @equipped_weapon = nil
      else
        @equipped_weapon.hit(target)
      end
    end
  end

  def attack!(target)
    if target.is_a?(Robot)
      attack(target)
    else
      raise InvalidTargetError, "That's not a robot!"
    end
  end

  def in_range?(target)
    target.position[0].abs - self.position[0].abs <= @equipped_weapon.range && target.position[1].abs - self.position[1].abs <= @equipped_weapon.range
  end

  def eat_battery
    @shield = 50
  end


end
