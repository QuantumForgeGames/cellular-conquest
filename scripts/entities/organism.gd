extends CharacterBody2D
class_name Organism

signal died(enemy: Organism)

@export var initial_health: int = 10
var knockback := Vector2.ZERO

func _ready() -> void:
	$Hitbox.health = initial_health

func on_absorbed() -> void:
	queue_free()

func _on_hitbox_damage_recieved(_value: int) -> void:
	if $Hitbox.health <= 0:
		on_absorbed()

func on_win(loser: CharacterBody2D) -> void:
	pass

func on_knockback(velocity: Vector2):
	knockback = velocity
	$StateMachine.on_child_transitioned("Knockback")
