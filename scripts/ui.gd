extends CanvasLayer


@onready var size_value: Label = %SizeValue
@onready var player: Player = $"../Player"

@onready var dash_cooldown_timer: Timer = player.dash_timer
@onready var dash_ability_cooldown: TextureRect = $Control/MarginContainer/HBoxContainer/DashAbility

@onready var knockback_cooldown_timer: Timer = player.knockback_timer
@onready var knockback_ability_cooldown: TextureRect = $Control/MarginContainer/HBoxContainer/KnockbackAbility

@onready var shoot_cooldown_timer: Timer = player.attack_timer
@onready var shoot_ability_cooldown: TextureRect = $Control/MarginContainer/HBoxContainer/ShootAbility

# Called when the node enters the scene tree for the first time.
func _ready():
	EventManager.player_health_changed.connect(_on_player_health_changed)
	EventManager.game_over.connect(_on_game_over)
	_on_player_health_changed(player.get_node("Hitbox").health)
	
	EventManager.skill_level_changed.connect(_on_skill_level_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dash_cooldown_timer.time_left != 0:
		dash_ability_cooldown.set_progress(1 - (dash_cooldown_timer.time_left / dash_cooldown_timer.wait_time))
	else:
		dash_ability_cooldown.set_progress(1.0)

	if knockback_cooldown_timer.time_left != 0:
		knockback_ability_cooldown.set_progress(1 - (knockback_cooldown_timer.time_left / knockback_cooldown_timer.wait_time))
	else:
		knockback_ability_cooldown.set_progress(1.0)

	if shoot_cooldown_timer.time_left != 0:
		shoot_ability_cooldown.set_progress(1 - (shoot_cooldown_timer.time_left / shoot_cooldown_timer.wait_time))
	else:
		shoot_ability_cooldown.set_progress(1.0)

func _on_player_health_changed(health: int):
	size_value.text = str(health)

func _on_game_over():
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_skill_level_changed(skill: String, level: int):
	get_node("Control/MarginContainer/HBoxContainer/" + skill + "Ability" + "/Label").text = "LVL " + str(level)
