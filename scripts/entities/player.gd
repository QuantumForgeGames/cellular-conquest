extends CharacterBody2D

# Basic controller
@export var MAX_SPEED := 400.
@export var MAX_MOUSE_DIST := 100.

# Health/Size 
@export var BASE_HEALTH := 1
@export var BASE_SIZE: float = scale.x 
@export var SIZE_SCALE_FACTOR := 0.01 # factor relating size and health
@export var SIZE_TWEEN_RATE := 0.01 # REVISIT! linear rate might not be feasible for larger sizes
@export var health: int = BASE_HEALTH :
	set (value):
		update_size(value, health)
		health = value

var size_tween: Tween = null

# Dash ability
@export var DASH_SPEED := 1000.
@export var DASH_DURATION := 0.3
@export var DASH_DEADZONE := 10 # in pixels

var dash_direction := Vector2.ZERO
var is_dashing: bool = false

# Projectile ability
@export var PROJECTILE_SPEED := 1000.
var projectile_scene := preload("res://scenes/entities/projectile.tscn")

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
	
	if Input.is_action_just_pressed("shoot"):
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		projectile.velocity = PROJECTILE_SPEED * (get_global_mouse_position() - global_position).normalized()
		add_sibling(projectile)

func toggle_dash():
	is_dashing = not is_dashing

func update_size(old_health: int, current_health: int):
	var target_scale := (SIZE_SCALE_FACTOR * (old_health - BASE_HEALTH) + BASE_SIZE) * Vector2.ONE
	
	if size_tween: size_tween.kill()
	size_tween = get_tree().create_tween()
	size_tween.tween_property(self, "scale", target_scale, SIZE_TWEEN_RATE * abs(current_health - old_health))
