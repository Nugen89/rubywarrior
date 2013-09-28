class Player

	UNSAFE_HEALTH = 10
	@health = 20

  def play_turn(warrior)
  	set_health_variable(warrior)

  	if ((warrior.health < @health) && (warrior.feel.empty?))
  		advance_and_attack(warrior)
  	else
  		advance_and_attack(warrior) 
  		# unless rest_when_low_health(warrior)
  	end

  	@health = warrior.health
  end


  def set_health_variable(warrior)
  	@health ||= warrior.health
  end

  def attacked_by_melee?(warrior)
  	((warrior.health < @health) && (warrior.feel.empty?))
  end

  def advance_and_attack(warrior)
    if warrior.feel.empty?
    	warrior.walk!
    else
    	if check_if_captive(warrior)
    		warrior.rescue!
    	else
				warrior.attack!
    	end
    end
  end

  def rest_when_low_health(warrior)
  	if (warrior.health < UNSAFE_HEALTH)
  		retreat_and_heal(warrior) # always true
		elsif warrior.health < 20 && warrior.feel.empty?
			warrior.rest!
			true
		else
			false
  	end
  end

  def retreat_and_heal(warrior)
  	if warrior.feel.empty?
  		warrior.rest!
  	else
  		warrior.walk!(:backward)
  	end
  	true
  end





  def retreat(warrior)
  	warrior.walk!(:backward)
  end

  def check_if_captive(warrior)
  	warrior.feel.captive?
  end

end

  	# if ((warrior.health < @health) && (warrior.feel.empty?))
  	# 	retreat(warrior)
  	# else
  	# 	advance_and_attack(warrior) unless rest_when_low_health(warrior)
  	# end
