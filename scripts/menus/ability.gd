

extends TextureRect

@onready var _ProgressBar = %ProgressBar


func set_progress(percent :float) -> void:
	_ProgressBar.value = clampf(percent, 0.0, 100.0)
