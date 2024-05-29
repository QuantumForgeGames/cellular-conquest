extends State

@export var ROTATION_SPEED_MIN := 0.075
@export var ROTATION_SPEED_MAX := 0.15
var rotation_speed = ROTATION_SPEED_MIN

@export var entity: CactusCube

func enter() -> void:
	entity.set_neutral_face()
	rotation_speed = randf_range(ROTATION_SPEED_MIN, ROTATION_SPEED_MAX) * [1, -1].pick_random()
	
func process(delta: float) -> void:
	entity.rotation += delta * rotation_speed
	
func on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		entity.target = body
		transitioned.emit("Chase")

