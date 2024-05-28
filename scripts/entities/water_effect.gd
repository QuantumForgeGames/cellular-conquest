extends Sprite2D

@export var _Player :CharacterBody2D

func _ready() -> void:
	EventManager.game_over.connect(_on_game_over)
	
func _process(delta :float) -> void:
	global_position = _Player.global_position
	
func _on_game_over() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
