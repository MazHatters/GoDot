extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

@onready var sprite = $AnimatedSprite2D

func _onready(delta):
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
		
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("box"):
		body.collision_layer = 1
		body.collision_mask = 1

func _on_area_2d_body_exited(body):
	if body.is_in_group("box"):
		body.collision_layer = 2
		body.collision_mask = 2
