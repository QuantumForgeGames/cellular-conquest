extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	SceneTransition.change_scene("res://scenes/menus/main_menu.tscn")
