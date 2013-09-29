require 'warrior'

class Player

	def initialize
		@prev_health = 20
		@prev_cells = {}
		@turns_made = 0
  end

  def play_turn(warrior)
  	@warrior = Warrior.new(warrior, @turns_made)
  	@warrior.prev_health = @prev_health

  	# puts @warrior.look.inspect
		@warrior.determine_action

  	set_previous_health(@warrior)
  	end_of_turn
  end

  private
  
	  def set_previous_health(warrior)
	  	@prev_health = warrior.health
	  end

	  def end_of_turn
	   	@turns_made += 1
	  	puts "END of turn: #{@turns_made}" 	
	  end

end
# 65DD3D35B2