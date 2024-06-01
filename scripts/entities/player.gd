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
@export var PROJECTILE_DAMAGE := 1

var projectile_scene := preload("res://scenes/entities/projectile.tscn")
var can_attack: bool = true

# Knockback ability
@onready var knockback_timer: Timer = $KnockbackCooldownTimer

@export var KNOCKBACK_STRENGTH: float = 500.
@export var KNOCKBACK_RADIUS: = 1. # does nothing as of now
@export var KNOCKBACK_DURATION :float = 0.5 

var can_knockback: bool = true
var is_knockback :bool = false

# Other
@onready var camera := $Camera2D
@export var knockback_particles_scene: PackedScene

# Player Stats
var cactus_points: int = 0
var tooth_points: int = 0
var bar_points: int = 0

var shoot_level: int = 0
var dash_level: int = 0 
var knockback_level: int = 0

var CACTUS_POINT_THRESHOLD: int = 5
var TOOTH_POINT_THRESHOLD: int = 5
var BAR_POINT_THRESHOLD: int = 5

func _ready() -> void:
	z_index = 1
	EnemySpawner.player = self
	$Hitbox.health = initial_health
	EventManager.player_health_changed.emit($Hitbox.health)
	EventManager.player_health_changed.connect(_on_player_health_changed)

func _physics_process(_delta: float) -> void:
	if is_knockback:
		velocity = lerp(velocity, Vector2.ZERO, 0.02)
	elif is_dashing:
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
		projectile.damage = PROJECTILE_DAMAGE
		add_sibling(projectile)
		attack_timer.start()
		
	if Input.is_action_just_pressed("knockback") and can_knockback:
		# add knockback particles onto global world
		var knockback_particles = knockback_particles_scene.instantiate()
		add_sibling(knockback_particles)
		knockback_particles.global_position = global_position
		knockback_particles.scale = scale
		knockback_particles.emitting = true

		can_knockback = false
		_apply_knockback()
		knockback_timer.start()

		toggle_face()
		get_tree().create_timer(0.5).timeout.connect(toggle_face)

func toggle_dash() -> void:
	is_dashing = not is_dashing
	toggle_face()
	$Hitbox/CollisionShape2D.set_deferred("disabled", not $Hitbox/CollisionShape2D.disabled)

func toggle_face() -> void:
	$Body/NeutralFace.visible = not $Body/NeutralFace.visible
	$Body/AngryFace.visible = not $Body/AngryFace.visible

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

func on_win(loser: CharacterBody2D) -> void:
	EventManager.player_health_changed.emit($Hitbox.health)
	if loser is CactusCube:
		cactus_points += 1
	if loser is ToothDasher:
		tooth_points += 1
		
	upgrade_abilities()

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

func _apply_knockback() -> void:
	for body in $KnockbackArea.get_overlapping_bodies():
		if body is Organism:
			var dir = (body.global_position - global_position)
			#var attenuation = (1 - dir.length() / $KnockbackArea/CollisionShape2D.shape.radius)
			body.on_knockback(KNOCKBACK_STRENGTH * dir.normalized())


func on_knockback (knockback :Vector2) -> void:
	velocity = knockback
	is_knockback = true
	get_tree().create_timer(KNOCKBACK_DURATION).timeout.connect(func():
		is_knockback = false
	)

func _on_dash_damage_area_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		if scale.x > area.entity.scale.x:
			$Hitbox.health += area.health
			area.entity.on_absorbed()
			on_win(area.entity)
			EventManager.player_health_changed.emit($Hitbox.health)
		else:
			area.on_damage_recieved(DASH_DAMAGE)

func _on_player_health_changed(health: int) -> void:
	if (0.25 * $Body.texture.get_width() * scale.y) * camera.zoom.y >= (0.6 * get_viewport_rect().size.y):
		var tween = get_tree().create_tween()
		tween.tween_property(camera, "zoom", 0.2 * camera.zoom, 4.)

func upgrade_abilities():
	# logic goes here for changing ability strengths based on stats
	var new_shoot_level = (cactus_points / CACTUS_POINT_THRESHOLD)

	if shoot_level < new_shoot_level:
		shoot_level = new_shoot_level
		PROJECTILE_DAMAGE += 1 # upgrade projectile strength
		EventManager.skill_level_changed.emit("Shoot", shoot_level)
		
	var new_dash_level = (tooth_points / TOOTH_POINT_THRESHOLD)

	if dash_level < new_dash_level:
		dash_level = new_dash_level
		DASH_DAMAGE += 1 # upgrade dash damage
		EventManager.skill_level_changed.emit("Dash", dash_level)
		
	var new_knockback_level = (bar_points / BAR_POINT_THRESHOLD)

	if knockback_level < new_knockback_level:
		knockback_level = new_knockback_level
		KNOCKBACK_STRENGTH += 50. # upgrade knockback strength
		EventManager.skill_level_changed.emit("Knockback", shoot_level)
