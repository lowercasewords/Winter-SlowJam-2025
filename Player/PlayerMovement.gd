extends CharacterBody2D

# The ability type enums
const PlayerEnums = preload("res://Player/Globals/PlayerEnums.gd")

# Left and right directional inputs of the player
var direction = Vector2(0, 0)
@export var speed: float = 200.0  # Movement speed
@export var jump_force: float = 350.0  # Jump strength
@export var gravity: float = 800.0  # Gravity force

# Coyote time (allows jumping slightly after leaving a platform)
@export var coyote_time: float = 0.1
var coyote_timer: float = 0.0
# Variable jump height
@export var jump_cut_multiplier: float = 0.5

# Is the player supposed to be dashing during this physics tic?
var is_dashing: bool = false
var dash_timer: float = 0.0
@export var dash_speed: float = 500.0  # Dash speed
@export var dash_time: float = 0.2  # Dash duration
@export var dash_aftermath_time: float = -0.3  # Duration after dash that makes the player be stuck in the air

func _physics_process(delta):
    # Apply gravity
    if not is_on_floor():
        velocity.y += gravity * delta

    # Coyote time logic
    if is_on_floor():
        coyote_timer = coyote_time
    else:
        coyote_timer -= delta

    # Get input direction (-1 = left, 1 = right, 0 = idle)
    direction = Input.get_axis("pl_left", "pl_right")

    # Dashing
    if(is_dashing): 
        if dash_timer > 0: # Apply dash force
            velocity = Vector2(direction *  dash_speed, 0)  
        elif(dash_timer < dash_aftermath_time): # The timer endeds, so is dashing
            is_dashing = false
        elif(direction): # When timer is between aftermath time and 0
            velocity = Vector2(0, 0)  
        else: # No inputs, no dash
            is_dashing = false
            dash_timer = dash_aftermath_time + delta # Reset the timer but account for subtraction
        dash_timer -= delta
    # Regular movement
    elif direction:
        #else: # Regular movement left and right
            velocity.x = direction * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed * delta)  # Smooth stopping
        
    try_jump(delta)

    move_and_slide()

func try_jump(delta):
    # Jumping with Coyote Time
    if Input.is_action_just_pressed("pl_jump") and coyote_timer > 0:
        velocity.y = -jump_force
        coyote_timer = 0  # Prevents double jumps

    # Variable jump height (cut jump short if button is released early)
    if Input.is_action_just_released("pl_jump") and velocity.y < 0:
        velocity.y *= jump_cut_multiplier
    

func _on_rhythm_rhythm_check_success(ability: PlayerEnums.AbilityType):
    match(ability):
        PlayerEnums.AbilityType.PIANO:
            is_dashing = true
            dash_timer = dash_time

    pass # Replace with function body.


func _on_rhythm_rhythm_check_failure(ability):
    pass # Replace with function body.
