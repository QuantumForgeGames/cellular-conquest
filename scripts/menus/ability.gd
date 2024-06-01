extends TextureRect

func set_progress(percent :float) -> void:
	material.set_shader_parameter("percent", 1. - clampf(percent, 0.0, 1.0))
