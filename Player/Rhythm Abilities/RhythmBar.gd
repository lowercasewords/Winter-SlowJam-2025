#extends Node2D
#
## Dictates how a rhythm bar would behave itself
#
#@onready
#var parent_panel: Panel = get_parent() # Where is the bar located?
#@onready
#var elapse_tic_counter: float = get_meta("tics_until_elapsed") # Counts down to zero
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#
	#var parent_panel_center_x = parent_panel.position.x - parent_panel.size.x / 2 # Retrieve the x-axis position of the parent panel center 
	#var max_tics: float = get_meta("tics_until_elapsed") # The maximum amount of tics the pair of bars would be alive
	#var scalar: float = parent_panel.size.x # Maxes sure the bar's position would be within bounds of parent panel background
	#var elapse_ratio: float = elapse_tic_counter/max_tics # A percentage number represented as a float (current value over total value)
	#
	#
	#if(elapse_ratio < 0.45): # When the bar reaches a certain point
		#self.queue_free() # Kill the bar if half of the tics are done (meet in the middle)
		#
	#elif(self.get_meta("is_left_bar")): # Left bar movement
		#self.position.x = scalar * elapse_ratio
		#
	#else: # right bar movement
		#self.position.x = scalar - (scalar * elapse_ratio)
	#
	## Counting down
	#elapse_tic_counter -= 1

extends Node2D

@onready var parent_panel: Panel = get_parent() # Panel reference
@onready var elapse_tic_counter: float = get_meta("tics_until_elapsed") # Countdown
@export var bar_speed: float = 200.0

func _process(delta):
	var parent_panel_center_x = parent_panel.size.x / 2  # Center of the panel

	# Move bar at a constant speed towards the center
	if get_meta("is_left_bar"):
		self.position.x += bar_speed * delta  # Move right
	else:
		self.position.x -= bar_speed * delta  # Move left

	# If the bar reaches the middle, remove it
	if abs(self.position.x - parent_panel_center_x) < 5:
		queue_free()

	elapse_tic_counter -= 1 * delta


#func _process(delta):
	#var parent_panel_center_x = parent_panel.position.x - parent_panel.size.x / 2 # Panel center
	#var max_tics: float = get_meta("tics_until_elapsed") # Maximum tic duration
	#var scalar: float = parent_panel.size.x # Panel width
	#var elapse_ratio: float = elapse_tic_counter / max_tics # Current progress (0.0 - 1.0)
	#
	#if elapse_ratio < 0.45: # Stop when the bars meet in the middle
		#self.queue_free()
	#elif self.get_meta("is_left_bar"): # Move left bar
		#self.position.x = scalar * elapse_ratio
	#else: # Move right bar
		#self.position.x = scalar - (scalar * elapse_ratio)
#
	## Count down based on speed multiplier
	#elapse_tic_counter -= speed_multiplier * delta * 60  # Adjust speed dynamically
