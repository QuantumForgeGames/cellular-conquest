extends CharacterBody2D
class_name Organism

@export var initial_health: int = 10

func _ready() -> void:
	$Hitbox.health = initial_health

func on_absorbed() -> void:
	queue_free()

func _on_hitbox_damage_recieved() -> void:
	if $Hitbox.health <= 0:
		on_absorbed()
