require 'delegate'

# DIRECTIONS.each {|d| adjacent_cells[d] = :enemy if feel(d).enemy?}

class Warrior < SimpleDelegator

	DIRECTIONS = [:forward, :backward, :left, :right]
	MAX_HEALTH = 20
	LOW_HEALTH = 8

	def initialize(warrior)
		super(warrior)
		@adjacent_cells = feel_for_enemies
		@nearby_enemies = feel_for_enemies.count
	end

	def determine_action

		puts "ESCAPE: #{escape_paths.inspect}"
		puts "ADJACENT: #{@adjacent_cells}"
		puts "CAPTIVES: #{feel_for_captives}"

		if @nearby_enemies > 1
			bind_enemies
		elsif (@nearby_enemies == 0) && (feel_for_captives.count > 0)
			free_captives unless retreat_and_heal
		else
			advance_and_attack unless retreat_and_heal
		end
	end

	def bind_enemies
		@adjacent_cells.each do |direction, enemy|
			if enemy
				bind!(direction)
				@adjacent_cells[direction] = :bounded
				return
			else				
				# if feel(direction_of_stairs).enemy?
				# 	attack!(direction_of_stairs)
				# else
				# 	walk!(direction_of_stairs)
				# end
				# return
			end
		end
	end

	def free_captives
		if feel_for_captives.count > 0
			feel_for_captives.each do |direction, captive|
				# puts "-----"
				# puts feel(direction).inspect
				# puts feel(direction).enemy?
				# puts feel(direction).to_s
				if feel(direction).to_s == "Captive"
					rescue!(direction)
					return
				end
			end
		else
			advance_and_attack
		end
	end

	def prev_health=(value)
		@prev_health = value
	end

	private

		def escape_paths
			DIRECTIONS.inject([]) {|paths, d| paths << d if feel(d).empty?; paths }
		end

		def feel_for_enemies
			DIRECTIONS.inject({}) {|hash, d| hash[d] = :enemy if feel(d).enemy?; hash} 
		end

		def feel_for_captives
			DIRECTIONS.inject({}) {|hash, d| hash[d] = :captive if feel(d).to_s == "Captive"; hash} 
		end

		def look_around
			DIRECTIONS.each { |direction| @cells[direction] = look(direction) }
		end

		def taking_damage?
			health < (@prev_health || 20)
		end

		def advance_and_attack
			if feel(direction_of_stairs).enemy?
				attack!(direction_of_stairs)
			else
				walk!(direction_of_stairs)
			end
		end

		def retreat_and_heal
			if (health <= LOW_HEALTH) && taking_damage? && (escape_paths.count > 0)
				walk!(escape_paths.first)
			elsif health < MAX_HEALTH-1 && !taking_damage? && (@nearby_enemies == 0)
				rest!
			else
				false
			end
		end

end
