extends Control

var burner_id :int = 0


func _ready () -> void:
	Wwise.register_game_obj(self, self.name)


func _on_play_button_pressed():
	Wwise.post_event_id(AK.EVENTS.PLAY_PLAY_V1, self)
	# Wwise.post_event_id(AK.EVENTS.PLAY_HOVER_V1, self)
	SceneTransition.change_scene("res://scenes/menus/instructions.tscn")


func _on_settings_button_pressed():
	Wwise.post_event_id(AK.EVENTS.PLAY_SETTINGS_V1, self)
	get_tree().change_scene_to_file("res://scenes/menus/settings_menu.tscn")


func _on_hover () -> void:
	Wwise.post_event_id(AK.EVENTS.PLAY_BURNERON_V1, self)
	burner_id = Wwise.post_event_id(AK.EVENTS.PLAY_BURNERLOOP_V2, self)


func _on_exit_hover () -> void:
	Wwise.stop_event(burner_id, 1, 1)