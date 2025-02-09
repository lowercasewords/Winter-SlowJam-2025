extends Node2D

@onready var pause_menu = $Player/inGameMenu
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if Input.is_action_just_pressed("pause") && pause_menu.on_pause_menu:
        _pause_menu()
    elif  Input.is_action_just_pressed("pause") && pause_menu.on_setting_menu:
        pause_menu._on_back_pressed()
    elif Input.is_action_just_pressed("pause") && pause_menu.on_warning_menu:
        pause_menu._on_no_pressed()

func _pause_menu():
    if paused:
        pause_menu.hide()
        Engine.time_scale = 1
        emit_signal("gamePaused")
    else:
        pause_menu.show()
        Engine.time_scale = 0
        emit_signal("gamePaused")
    paused = !paused
