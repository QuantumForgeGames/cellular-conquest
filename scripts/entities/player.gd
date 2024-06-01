extends CharacterBody2D
class_name Player

# Basic controller
@export var MAX_SPEED := 400.
@export var MAX_MOUSE_DIST := 100.
@export var initial_health: int = 5

# Dash ability
@onready var dash_timer: Timer = $DashCooldownTimer

@export var DASH_SPEED := 1200.
@export var DASH_DURATION := 0.4
@export var DASH_DEADZONE := 10 # in pixels
@export var DASH_DAMAGE := 0

var dash_direction := Vector2.ZERO
var is_dashing: bool = false
var can_dash: bool = true

# Projectile ability
@onready var attack_timer: Timer = $AttackCooldownTimer

@export var PROJECTILE_SPEED := 1000.

var projectile_scene := preload("res://scenes/entities/projectile.tscn")
var can_attack: bool = true

# Knockback ability
@onready var knockback_timer: Timer = $KnockbackCooldownTimer

@export var KNOCKBACK_STRENGTH: float = 400.
@export var KNOCKBACK_RADIUS: = 1. # does nothing as of now

var can_knockback: bool = true

# other
@onready var camera := $Camera2D

func _ready() -> void:
	z_index = 1
	EnemySpawner.player = self
	$Hitbox.health = initial_health
	EventManager.player_health_changed.emit($Hitbox.health)
	EventManager.player_health_changed.connect(_on_player_health_changed)
	
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
	
	if Input.is_action_pressed("shoot") and can_attack:
		can_attack = false
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		projectile.velocity = PROJECTILE_SPEED * (get_global_mouse_position() - global_position).normalized()
		projectile.rotation = projectile.velocity.angle()
		projectile.scale = scale
		add_sibling(projectile)
		attack_timer.start()
		
	if Input.is_action_just_pressed("knockback") and can_knockback:
		$KnockbackParticles.emitting = true
		can_knockback = false
		_apply_knockback()
		knockback_timer.start()

func toggle_dash() -> void:
	is_dashing = not is_dashing
	$Body/NeutralFace.visible = not $Body/NeutralFace.visible
	$Body/AngryFace.visible = not $Body/AngryFace.visible
	$Hitbox/CollisionShape2D.set_deferred("disabled", not $Hitbox/CollisionShape2D.disabled)
	
func on_absorbed() -> void:
	$Camera2D.reparent(get_parent())
	$Hitbox.queue_free()
	EventManager.player_health_changed.emit(0)
	EventManager.game_over.emit()
	
	z_index = 0
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 1.)
	tween.tween_callback(queue_free)

func on_win() -> void:
	EventManager.player_health_changed.emit($Hitbox.health)

func _on_dash_cooldown_timer_timeout():
	can_dash = true

func _on_attack_cooldown_timer_timeout():
	can_attack = true

func _on_knockback_cooldown_timer_timeout() -> void:
	can_knockback = true

func _on_hitbox_damage_recieved(_value: float) -> void:
	EventManager.player_health_changed.emit($Hitbox.health)
	if $Hitbox.health <= 0:
		on_absorbed()

func _apply_knockback():
	for body in $KnockbackArea.get_overlapping_bodies():
		if body is Organism:
			var dir = (body.global_position - global_position)
			#var attenuation = (1 - dir.length() / $KnockbackArea/CollisionShape2D.shape.radius)
			body.on_knockback(KNOCKBACK_STRENGTH * dir.normalized())

func _on_dash_damage_area_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		if scale.x > area.entity.scale.x:
			$Hitbox.health += area.health
			area.entity.on_absorbed()
			EventManager.player_health_changed.emit($Hitbox.health)
		else:
			area.on_damage_recieved(DASH_DAMAGE)

func _on_player_health_changed(health: int) -> void:
	if (0.25 * $Body.texture.get_width() * scale.y) * camera.zoom.y >= (0.6 * get_viewport_rect().size.y):
		var tween = get_tree().create_tween()
		tween.tween_property(camera, "zoom", 0.2 * camera.zoom, 4.)

