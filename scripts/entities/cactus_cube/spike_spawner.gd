extends Node

var spike_scene = preload("res://scenes/entities/spike_projectile.tscn")

func spawn(position: Vector2, rotation: float, scale: Vector2, target: Node2D) -> void:
	var spike = spike_scene.instantiate()
	target.add_child(spike)
	spike.global_position = position
	spike.rotation = rotation
	spike.scale = scale
	
