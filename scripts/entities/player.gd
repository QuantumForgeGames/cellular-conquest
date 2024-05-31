extends CharacterBody2D
class_name Player

# Basic controller
@export var MAX_SPEED := 400.
@export var MAX_MOUSE_DIST := 100.
@export var initial_health: int = 5

# Dash ability
@export var DASH_SPEED := 1200.
@export var DASH_DURATION := 0.3
@export var DASH_DEADZONE := 10 # in pixels

var dash_direction := Vector2.ZERO
var is_dashing: bool = false
var can_dash: bool = true

# Projectile ability
@export var PROJECTILE_SPEED := 1000.
var projectile_scene := preload("res://scenes/entities/projectile.tscn")

# Other
var can_attack: bool = true
@onready var dash_timer: Timer = $DashCooldownTimer
@onready var attack_timer: Timer = $AttackCooldownTimer

func _ready() -> void:
	EnemySpawner.player = self
	$Hitbox.health = initial_health
	EventManager.player_health_changed.emit($Hitbox.health)
	
func _physics_process(_delta: float) -> void:
	if is_dashing:
		velocity = DASH_SPEED * dash_direction
	else:		
		velocity = MAX_SPEED * (get_global_mouse_position() - global_position).limit_length(MAX_MOUSE_DIST) / MAX_MOUSE_DIST
		
	move_and_slide()

func _input(_event: InputEvent) -> void:
	if not is_dashing and can_dash and Input.is_action_just_pressed("dash"):
		toggle_dash()
		can_dash = false
		var dir = (get_global_mouse_position() - global_position)
		dash_direction = (dir.normalized()) if (dir.length() > DASH_DEADZONE) else Vector2.ZERO
		get_tree().create_timer(DASH_DURATION).timeout.connect(toggle_dash)
		dash_timer.start()
	
	if Input.is_action_just_pressed("shoot") and can_attack:
		can_attack = false
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		projectile.velocity = PROJECTILE_SPEED * (get_global_mouse_position() - global_position).normalized()
		add_sibling(projectile)
		attack_timer.start()

func toggle_dash() -> void:
	is_dashing = not is_dashing
	$Body/NeutralFace.visible = not $Body/NeutralFace.visible
	$Body/AngryFace.visible = not $Body/AngryFace.visible

func on_absorbed() -> void:
	print("Absorbed! (Debug)")
	#EventManager.game_over.emit()
	#$Camera2D.reparent(get_parent())
	#$EventManager.player_health_changed.emit($Hitbox.health)
	#queue_free()
	
func _on_dash_cooldown_timer_timeout():
	can_dash = true

func _on_attack_cooldown_timer_timeout():
	can_attack = true

func _on_hitbox_damage_recieved(_value: float) -> void:
	EventManager.player_health_changed.emit($Hitbox.health)
