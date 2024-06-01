extends State

@export var entity: Organism
@export var STUN_DURATION := 1.0

func enter() -> void:
	entity.velocity = entity.knockback
	get_tree().create_timer(STUN_DURATION).timeout.connect(_on_stun_timeout)

func process(delta: float) -> void:
	entity.move_and_slide()
	entity.knockback = lerp(entity.knockback, Vector2.ZERO, 0.8)
	
func _on_stun_timeout() -> void:
	entity.knockback = Vector2.ZERO
	entity.velocity = Vector2.ZERO
	transitioned.emit("Idle")
