extends State

@export var entity: ToothDasher

var dashing :bool = false


func enter () -> void:
    entity.set_angry_face()
    entity.dash_wait_timer.start()


func exit () -> void:
    entity.dash_wait_timer.stop()


func process (_delta: float) -> void:
    var direction = entity.target.global_position - entity.global_position
    var angle_to_target = (direction).angle()
    entity.rotation = lerp_angle(entity.rotation, angle_to_target + PI/2, 0.1)

    if dashing:
        entity.velocity = direction.normalized() * entity.DASH_SPEED
        entity.move_and_slide()


func on_detection_area_body_entered (body: Node2D) -> void:
    if body is Player:
        enter()


func on_detection_area_body_exited (body: Node2D) -> void:
    if body is Player:
        entity.target = null
        entity.dash_wait_timer.stop()
        transitioned.emit("Idle")


func _on_dash_wait_timer_timeout () -> void:
    dashing = true
    get_tree().create_timer(entity.DASH_DURATION).timeout.connect(func():
        dashing = false
        transitioned.emit("Chase")
    )
