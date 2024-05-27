extends CharacterBody2D

@export var MAX_SPEED := 400.
@export var MAX_MOUSE_DIST := 100.

func _physics_process(delta: float) -> void:
	velocity = MAX_SPEED * (get_global_mouse_position() - global_position).limit_length(MAX_MOUSE_DIST) / MAX_MOUSE_DIST
	move_and_slide()
