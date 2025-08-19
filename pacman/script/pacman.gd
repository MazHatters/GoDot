extends CharacterBody2D


const SPEED = 150.0
var moving = false # To show which input gets priority
#const JUMP_VELOCITY = -400.0
@onready var sprite= $AnimatedSprite2D


func _physics_process(delta):
	# Get inputs
	var dirx := Input.get_axis("ui_left", "ui_right")
	var diry := Input.get_axis("ui_up", "ui_down")

	# Apply movement
	if dirx != 0:
		velocity.x = dirx * SPEED
		sprite.flip_h = dirx < 0
	else:
		velocity.x = move_toward(velocity.x, 0 , SPEED)

	if diry != 0:
		velocity.y = diry * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Determine if moving
	moving = dirx != 0 or diry != 0

	# Play animation
	if moving:
		sprite.play("moving")
	else:
		sprite.play("idle")

	move_and_slide()
