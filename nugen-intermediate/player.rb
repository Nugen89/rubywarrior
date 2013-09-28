require 'warrior'

class Player

	def initialize
		@prev_health = 20
		@prev_cells = {}
		@turns_made = 0
  end

  def play_turn(warrior)
  	@warrior = Warrior.new(warrior)
  	@warrior.prev_health = @prev_health

		@warrior.determine_action

  	set_previous_health(@warrior)
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
