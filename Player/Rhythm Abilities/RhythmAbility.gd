extends Control

# This scripts handles the individual ability rhythm panel. It is responsible for creation of rhythm bars and 
# sending signal on whether the player succeded or failed the rhythm check.

signal rhythm_check_success(ability: PlayerEnums.AbilityType)
signal rhythm_check_failure(ability: PlayerEnums.AbilityType)

# The ability type enums
const PlayerEnums = preload("res://Player/Globals/PlayerEnums.gd")

@onready var panel_background: Panel = $Background # The panel on which the bars would appear
@onready var rhythmcheck_register_area: Area2D = $DetectRange # The middle area where pair of bars have to be to succeed
@onready var bar_packed_scene: PackedScene = load("res://Player/Rhythm Abilities/RhythmBar.tscn") # A bar
@onready var note_sound_player: AudioStreamPlayer2D = $Note
@export var spawn_time = 60 # How long it takes for a new pair of bars to spawn in ics
@export var reaction_error_time = 10 # The extra time given after bars already gone when the player is still able to pass a rhythm chek
var reaction_error_timer = 0 # The timer that counts down to zero
var spawn_timer = spawn_time # This timer counts down to zero, spawning a pair of bars each time reaches 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("ability_type", PlayerEnums.AbilityType.PIANO)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var overlapping_areas = rhythmcheck_register_area.get_overlapping_areas()
	if((not overlapping_areas.is_empty() or reaction_error_timer > 0) and Input.is_action_just_pressed("pl_ability_1")):
		emit_signal("rhythm_check_success", PlayerEnums.AbilityType.PIANO)
	
	# Spawn a new pair of bars when countdown finished
	if(spawn_timer <= 0):
		# Instantiate the bar
		var right_bar: Node2D = bar_packed_scene.instantiate()
		var left_bar: Node2D = bar_packed_scene.instantiate()
		
		# Make sure the bar knows on what side it is
		right_bar.set_meta("is_right_bar", false)
		left_bar.set_meta("is_left_bar", true)
		
		right_bar.set_meta("tics_until_elapsed", spawn_time)
		left_bar.set_meta("tics_until_elapsed", spawn_time)
		
		# Adjust the right bar to actually appaer on the right
		right_bar.position = Vector2(panel_background.size.x, 0)
		
		# Introduce the bars into the scene as children of panel background
		panel_background.add_child(right_bar)
		panel_background.add_child(left_bar)
		
		emit_signal("rhythm_check_failure", PlayerEnums.AbilityType.PIANO)
		spawn_timer = spawn_time
	else:
		# Count down the spawn timer
		spawn_timer -= 1
		
	# Counting down the error timer
	if(reaction_error_timer > 0):
		reaction_error_timer -= 1


func _on_area_2d_area_entered(area):
	# Player makes a successful rhythm check
	#if(Input.is_action_just_pressed("pl_ability_1")):
		#emit_signal("rhythm_checjk_success")
	pass

# The pair of bars have been removed (met in the middle). Since there's a pair of bars, this function might be called twice 
func _on_detect_range_area_exited(area):
	note_sound_player.play()
	reaction_error_timer = reaction_error_time
