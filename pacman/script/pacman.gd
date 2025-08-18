extends CharacterBody2D


const SPEED = 150.0
#const JUMP_VELOCITY = -400.0
@onready var sprite= $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Handles left and right
	var dirx := Input.get_axis("ui_left", "ui_right")
	if dirx:
		if dirx < 0:
			sprite.flip_h = true
			sprite.play("moving")
		if dirx > 0:
			sprite.flip_h = false
			sprite.play("moving")
		velocity.x = dirx * SPEED
	else:
		sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handles up and down
	var diry := Input.get_axis("ui_up", "ui_down")
	if diry:
		if diry < 0:
			#sprite.rotation = diry
			sprite.play("moving")
		if diry > 0:
			#sprite.rotation = diry
			sprite.play("moving")
		velocity.y = diry * SPEED
	else:
		sprite.play("idle")
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
