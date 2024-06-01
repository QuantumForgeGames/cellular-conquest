extends Control


func _ready () -> void:
	Wwise.register_game_obj(self, self.name)


func _on_play_button_pressed():
	Wwise.post_event_id(AK.EVENTS.PLAY_PLAY_V1, self)
	SceneTransition.change_scene("res://scenes/levels/world.tscn")


func _on_settings_button_pressed():
	Wwise.post_event_id(AK.EVENTS.PLAY_SETTINGS_V1, self)
	get_tree().change_scene_to_file("res://scenes/menus/settings_menu.tscn")
