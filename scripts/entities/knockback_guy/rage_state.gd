extends State

@export var entity: KnockbackGuy
@export var knockback_particles_scene :PackedScene
@export var KNOCKBACK_STRENGTH :float = 1000.

var dashing :bool = false


func enter () -> void:
    entity.set_angry_face()
    _apply_knockback()
    entity.knockback_cooldown_timer.start()


func exit () -> void:
    entity.knockback_cooldown_timer.stop()


func on_detection_area_body_exited (body: Node2D) -> void:
    if body is Player:
        entity.target = null
        transitioned.emit("Idle")


func _on_knockback_cooldown_timer_timeout () -> void:
    _apply_knockback()


func _apply_knockback () -> void:
    Wwise.post_event_id(AK.EVENTS.PLAY_PLAYERSHOCKWAVE_V1, self)
    var knockback_particles = knockback_particles_scene.instantiate()
    add_sibling(knockback_particles)
    knockback_particles.global_position = entity.global_position
    knockback_particles.scale = entity.scale
    knockback_particles.emitting = true

    for body in entity.detection_area.get_overlapping_bodies():
        if body == entity: continue
        var dir  = body.global_position - entity.global_position
        # var attenuation = 1 - (dir.length() / entity.detection_area.get_child(0).shape.radius)
        body.on_knockback(KNOCKBACK_STRENGTH * dir.normalized())
