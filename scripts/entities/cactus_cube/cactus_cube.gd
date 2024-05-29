class_name CactusCube
extends Organism

@export var rage_timer: Timer
@export var angry_face: Sprite2D
@export var neutral_face: Sprite2D

var target: Player = null

func _ready() -> void:
	$Hitbox.health = initial_health

func on_absorbed() -> void:
	queue_free()

func _on_hitbox_damage_recieved(value: int) -> void:
	if $Hitbox.health <= 0:
		on_absorbed()

func set_angry_face() -> void:
	angry_face.visible = true
	neutral_face.visible = false
	
func set_neutral_face() -> void:
	angry_face.visible = false
	neutral_face.visible = true
