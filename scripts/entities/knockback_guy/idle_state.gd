extends State


@export var ROTATION_SPEED_MIN := 0.075
@export var ROTATION_SPEED_MAX := 0.15
var rotation_speed = ROTATION_SPEED_MIN

@export var entity: KnockbackGuy


func enter() -> void:
    entity.set_neutral_face()

    get_tree().create_tween().set_loops().tween_callback(func():
        rotation_speed = randf_range(ROTATION_SPEED_MIN, ROTATION_SPEED_MAX) * [1, -1].pick_random()
        await get_tree().create_timer(randf_range(0.5, 3.5)).timeout
        rotation_speed = 0.0
    ).set_delay(4)


func process(delta: float) -> void:
    entity.rotation += delta * rotation_speed
    entity.velocity = entity.global_transform.y * entity.CHASE_SPEED
    entity.move_and_slide()


func on_detection_area_body_entered(body: Node2D) -> void:
    if body is Player:
        while body.is_dashing:
            await get_tree().create_timer(0.5).timeout
        entity.target = body
        transitioned.emit("Rage")


func on_detection_area_body_exited (_body :Node2D) -> void:
    # entity.target = _body
    transitioned.emit("Rage")
