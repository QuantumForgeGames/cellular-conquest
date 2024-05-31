extends State

@export var entity: ToothDasher


func enter() -> void:
    entity.set_neutral_face()
    entity.dash_cooldown_timer.start()


func exit () -> void:
    entity.dash_cooldown_timer.stop()


func process(_delta: float) -> void:
    if entity.target == null: return
    var direction = entity.target.global_position - entity.global_position
    var angle_to_target = (direction).angle()
    entity.rotation = lerp_angle(entity.rotation, angle_to_target + PI/2, 0.1)
    entity.velocity = direction.normalized() * entity.CHASE_SPEED
    entity.move_and_slide()


func on_detection_area_body_entered (body: Node2D) -> void:
    if body is Player:
        enter()


func on_detection_area_body_exited (body: Node2D) -> void:
    if body is Player:
        entity.target = null
        entity.dash_cooldown_timer.stop()
        transitioned.emit("Idle")


func _on_dash_cooldown_timer_timeout():
    transitioned.emit("Rage")
