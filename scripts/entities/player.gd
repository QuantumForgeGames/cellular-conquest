extends CharacterBody2D
class_name Player

# Basic controller
@export var MAX_SPEED := 400.
@export var MAX_MOUSE_DIST := 100.
@export var initial_health: int = 5

# Dash ability
@export var DASH_SPEED := 1000.
@export var DASH_DURATION := 0.3
@export var DASH_DEADZONE := 10 # in pixels

var dash_direction := Vector2.ZERO
var is_dashing: bool = false

# Projectile ability
@export var PROJECTILE_SPEED := 1000.
var projectile_scene := preload("res://scenes/entities/projectile.tscn")

func _ready() -> void:
	$Hitbox.health = initial_health

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

func toggle_dash() -> void:
	is_dashing = not is_dashing

func on_absorbed() -> void:
	queue_free()
	
