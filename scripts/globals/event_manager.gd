extends Node

signal game_over
signal player_health_changed(health: int)

func on_enemy_died(enemy, name: String) -> void:
	print(name)
