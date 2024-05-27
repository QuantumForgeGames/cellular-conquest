extends CharacterBody2D

# Basic controller
@export var MAX_SPEED := 400.
@export var MAX_MOUSE_DIST := 100.

# Dash ability
@export var DASH_SPEED := 1000.
@export var DASH_DURATION := 0.3
@export var DASH_DEADZONE := 10 # in pixels

var dash_direction := Vector2.ZERO
var is_dashing: bool = false

func _physics_process(_delta: float) -> void:
	if is_dashing:
		velocity = DASH_SPEED * dash_direction
	else:		
		velocity = MAX_SPEED * (get_global_mouse_position() - global_position).limit_length(MAX_MOUSE_DIST) / MAX_MOUSE_DIST
		
	move_and_slide()

func _input(_event: InputEvent) -> void:
	if not is_dashing and Input.is_action_just_pressed("dash"):
		is_dashing = true
		var dir = (get_global_mouse_position() - global_position)
		dash_direction = (dir.normalized()) if (dir.length() > DASH_DEADZONE) else Vector2.ZERO
		get_tree().create_timer(DASH_DURATION).timeout.connect(toggle_dash)
		
func toggle_dash():
	is_dashing = not is_dashing

