extends CanvasLayer

@onready var attack_box_sprite: AnimatedSprite2D = %AttackBoxSprite2D
@onready var dash_box_sprite: AnimatedSprite2D = %DashBoxSprite2D
@onready var size_value: Label = %SizeValue
@onready var player: Player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	size_value.text = str(player.health)

	if Input.is_action_just_pressed("dash"):
		dash_box_sprite.play("default")
		
	if Input.is_action_just_pressed("shoot"):
		attack_box_sprite.speed_scale = 4
		attack_box_sprite.play("default")
