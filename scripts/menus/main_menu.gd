extends Control

func _on_play_button_pressed():
	SceneTransition.change_scene("res://scenes/menus/instructions.tscn")

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/settings_menu.tscn")
