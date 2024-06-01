@tool

extends GPUParticles2D

const MAX_RADIUS :float = 250.0
const GROW_SPEED :float = 400.0

var _radius :float = 0.0
var _ratio :float = 2.0

func _process (delta :float) -> void:
    if _radius >= MAX_RADIUS:
        _ratio = 2.0
        _radius = 50.0
        get_child(0).amount_ratio = 1.0
    get_child(0).amount_ratio = max(0.15, get_child(0).amount_ratio - (delta * _ratio))
    _ratio += delta * 10

