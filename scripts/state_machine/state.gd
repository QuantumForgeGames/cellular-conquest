# adapted from https://www.sandromaglione.com/articles/how-to-implement-state-machine-pattern-in-godot
class_name State
extends Node
 
signal transitioned(new_state_name: StringName)
 
func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process(_delta: float) -> void:
	pass
 
func physics_process(_delta: float) -> void:
	pass

func on_damage_recieved(_damage: int) -> void:
	pass
	
func on_detection_area_body_entered(_body: CharacterBody2D) -> void:
	pass
	
func on_detection_area_body_exited(_body: CharacterBody2D) -> void:
	pass
