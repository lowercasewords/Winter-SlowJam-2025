extends CharacterBody2D

@export var speed: float = 200.0  # Movement speed
@export var jump_force: float = 350.0  # Jump strength
@export var gravity: float = 800.0  # Gravity force

# Coyote time (allows jumping slightly after leaving a platform)
@export var coyote_time: float = 0.1
var coyote_timer: float = 0.0

# Variable jump height
@export var jump_cut_multiplier: float = 0.5

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
	var direction = Input.get_axis("pl_left", "pl_right")

	# Move left and right
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)  # Smooth stopping

	# Jumping with Coyote Time
	if Input.is_action_just_pressed("pl_jump") and coyote_timer > 0:
		velocity.y = -jump_force
		coyote_timer = 0  # Prevents double jumps

	# Variable jump height (cut jump short if button is released early)
	if Input.is_action_just_released("pl_jump") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

	move_and_slide()
