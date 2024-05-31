extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	SceneTransition.change_scene("res://scenes/menus/main_menu.tscn")
