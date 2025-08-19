extends CharacterBody2D

const SPEED = 150.0
var moving = false
var last_dir = Vector2.RIGHT  # default facing right
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	var dirx := Input.get_axis("ui_left", "ui_right")
	var diry := Input.get_axis("ui_up", "ui_down")

	velocity = Vector2.ZERO
	moving = false

	# Horizontal movement
	if dirx != 0:
		velocity.x = dirx * SPEED
		sprite.play("moving_left_right")
		sprite.flip_h = dirx < 0
		last_dir = Vector2(dirx, 0)
		moving = true

	# Vertical movement
	elif diry != 0:
		velocity.y = diry * SPEED
		sprite.play("moving_up_down")
		sprite.flip_v = diry > 0
		last_dir = Vector2(0, diry)
		moving = true

	# Idle animation depends on last direction
	if !moving:
		if last_dir.x != 0:
			sprite.play("idle_left_right")
			sprite.flip_h = last_dir.x < 0
		elif last_dir.y != 0:
			sprite.play("idle_up_down")
			sprite.flip_v = last_dir.y > 0

	move_and_slide()
