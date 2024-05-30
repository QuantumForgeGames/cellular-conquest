extends State

@export var entity: CactusCube

func enter() -> void:
	entity.set_neutral_face()
	
func process(_delta: float) -> void:
	var angle_to_target = (entity.target.global_position - entity.global_position).angle()
	entity.rotation = lerp_angle(entity.rotation, angle_to_target + PI/2, 0.1)

func on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		entity.target = null
		transitioned.emit("Idle")

func on_damage_recieved(_value: int) -> void:
	transitioned.emit("Rage")
