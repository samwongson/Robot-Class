class CannotHealWhileDeadError < StandardError
end

class InvalidTargetError < StandardError
end

class Robot

  attr_reader :position, :items, :health, :max_health
  attr_accessor :equipped_weapon

  def initialize
    @position = [0,0]
    @items = []
    @health = 100
    @max_health = 100
    @equipped_weapon = nil
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
    if damage > @health
      @health -= @health
    else
      @health -= damage
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


end
