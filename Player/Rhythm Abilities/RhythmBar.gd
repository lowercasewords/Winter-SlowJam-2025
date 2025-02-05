extends Node2D

# Where is the bar located?
@onready
var parent_panel: Panel = get_parent()

# Counts down to zero
@onready
var elapse_tic_counter: float = get_meta("tics_until_elapsed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Retrieve the x-axis position of the parent panel center 
	var parent_panel_center_x = parent_panel.position.x - parent_panel.size.x / 2
	var scalar: float = parent_panel.size.x
	var max_tics: float = get_meta("tics_until_elapsed")
	
	# A percentage number represented as a float (current value over total value)
	var elapse_ratio: float = elapse_tic_counter/max_tics
	print(elapse_ratio)
	if(elapse_ratio < 0.5): # When the bar reaches a certain point
		self.queue_free() # Kill the bar if half of the tics are done (meet in the middle)
	elif(self.get_meta("is_left_bar")): # Left bar movement
		self.position.x = scalar * elapse_ratio
	else: # right bar movement
		self.position.x = scalar - (scalar * elapse_ratio)
	
	# Counting down
	elapse_tic_counter -= 1
