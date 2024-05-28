# adapted from https://www.sandromaglione.com/articles/how-to-implement-state-machine-pattern-in-godot
class_name State
extends Node
 
signal transitioned(new_state_name: StringName)
 
func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process(delta: float) -> void:
	pass
 
func physics_process(delta: float) -> void:
	pass
