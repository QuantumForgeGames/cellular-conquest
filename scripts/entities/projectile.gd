extends Area2D
class_name Projectile

@export var damage: int = 1
@export var despawn_time: float = 6.

var velocity := Vector2.ZERO

func _ready() -> void:
	get_tree().create_timer(despawn_time).timeout.connect(_on_hit)

func _physics_process(delta: float) -> void:
	position += velocity * delta	

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		area.on_damage_recieved(damage)
		_on_hit()
		
func _on_hit():
	# add destroy animation/particle effects
	queue_free()
