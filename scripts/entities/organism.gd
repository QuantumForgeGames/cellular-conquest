extends CharacterBody2D
class_name Organism

signal died(enemy: Organism)

@export var initial_health: int = 10
var knockback := Vector2.ZERO
var is_zooming: bool = false
var global_scale_factor: float = 1.

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

func zoom(scale_factor: float, duration: float, pos: Vector2):
	if get_tree():
		is_zooming = true
		if $Hitbox.size_tween: $Hitbox.size_tween.kill()
		$Hitbox.size_tween = get_tree().create_tween()
		$Hitbox.size_tween.tween_property(self, "scale", scale_factor * scale, duration)
		$Hitbox.size_tween.tween_callback(func (): is_zooming = false)
