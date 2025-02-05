extends Node2D

# Dictates how a rhythm bar would behave itself

@onready
var parent_panel: Panel = get_parent() # Where is the bar located?
@onready
var elapse_tic_counter: float = get_meta("tics_until_elapsed") # Counts down to zero

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var parent_panel_center_x = parent_panel.position.x - parent_panel.size.x / 2 # Retrieve the x-axis position of the parent panel center 
	var max_tics: float = get_meta("tics_until_elapsed") # The maximum amount of tics the pair of bars would be alive
	var scalar: float = parent_panel.size.x # Maxes sure the bar's position would be within bounds of parent panel background
	var elapse_ratio: float = elapse_tic_counter/max_tics # A percentage number represented as a float (current value over total value)
	
	
	if(elapse_ratio < 0.45): # When the bar reaches a certain point
		self.queue_free() # Kill the bar if half of the tics are done (meet in the middle)
		
	elif(self.get_meta("is_left_bar")): # Left bar movement
		self.position.x = scalar * elapse_ratio
		
	else: # right bar movement
		self.position.x = scalar - (scalar * elapse_ratio)
	
	# Counting down
	elapse_tic_counter -= 1
