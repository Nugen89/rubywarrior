require 'delegate'

class Warrior < SimpleDelegator

	DIRECTIONS = [:forward, :backward, :left, :right]
	MAX_HEALTH = 20
	LOW_HEALTH = 8

	def initialize(warrior, turn)
		super(warrior)
		@adjacent_cells = feel_for_enemies
		@nearby_enemies = feel_for_enemies.count
		@captives = listen_for_captives
		@turns_made = turn

		@target_captive = @captives.select {|captive| captive if captive.ticking?}.first
		@target_captive = @captives.first if @target_captive.nil?
		puts @target_captive.inspect
	end

	def determine_action

		puts "#{listen}"
		puts "ESCAPE: #{escape_paths.inspect}"
		puts "ADJACENT: #{@adjacent_cells}"
		puts "CAPTIVES: #{feel_for_captives}"
		puts "---------------------------"

		if @nearby_enemies > 1
			bind_enemies
		elsif enemies_in_a_row
			detonate! unless retreat_and_heal
		elsif (@nearby_enemies == 0) && (feel_for_captives.count > 0)
			free_captives 
			# unless retreat_and_heal
		elsif @captives.count > 0
			find_captives
		else
			advance_and_attack unless retreat_and_heal
		end

	end

	def find_captives
		if !feel(direction_of(@target_captive)).stairs? && feel(direction_of(@target_captive)).empty?
			walk!(direction_of(@target_captive))
		elsif feel(direction_of(@target_captive)).to_s != "Captive"
			attack!(direction_of(@target_captive))
		elsif feel(direction_of(@target_captive)).to_s == "Captive"
			rescue!(direction_of(@target_captive))
		else
			path_options = DIRECTIONS.select { |d| d if d != direction_of(@target_captive)  }
			path_options.each {|d| return walk!(d) if feel(d).empty? }
		end
	end

	def listen_for_captives
		listen.select { |target| target if target.to_s == "Captive" }
	end

	def bind_enemies
		@adjacent_cells.each do |direction, enemy|
			if enemy && (direction != direction_of(@target_captive))
				bind!(direction)
				@adjacent_cells[direction] = :bounded
				return
			end
		end
	end

	def free_captives
		if feel_for_captives.count > 0
			feel_for_captives.each do |direction, captive|
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

		def enemies_in_a_row
			look[0].enemy? && look[1].enemy?
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
