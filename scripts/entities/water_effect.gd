

extends Sprite2D


@export var _Player :CharacterBody2D

func _process (delta :float) -> void:

    global_position = _Player.global_position
