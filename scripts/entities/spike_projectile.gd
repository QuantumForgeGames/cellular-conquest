extends Area2D

@export var despawn_time: float = 5.
@export var speed: float = 600.
@export var damage: int = 2

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func launch() -> void:
	var angle = ($TipMarker.global_position - global_position).angle()
	direction = Vector2(cos(angle), sin(angle))
	
	reparent(get_tree().root)
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(despawn_time).timeout.connect(despawn)
		
func _process(delta: float) -> void:
	global_position += delta * speed * direction
	
func despawn() -> void:
	queue_free()

func _on_area_entered(body: Node2D) -> void:
	if body is Hitbox:
		body.on_damage_recieved(damage)
	despawn()
