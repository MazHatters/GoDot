extends CharacterBody2D

const GRAVITY : int = 1000			# <- How quick the bird drops (max fall accel)
const MAX_VEL : int = 600			# <- Max fall speed (max fall speed)
const FLAP_SPEED : int = -500		# <- How high the bird can fly when flapping
var flying : bool = false			# <- Only active if the bird doesn't collide with the pipe
var falling : bool = false			# <- Only active if the bird collides with the pipe
const START_POS = Vector2(100, 400)	# <- Starting coordinates of the bird

func _ready():
	reset()

func reset():
	falling = false			# <- Resets flag
	flying = false			# <- Resets flag
	position = START_POS		# <- Resets starting position
	set_rotation(0)			# <- Resets rotation if the bird was rotating
	
func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta
		# Setting max velocity, aka terminal velocity
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		# Rotating bird while alive
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		elif falling:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()    
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()
		
func flap():
	velocity.y = FLAP_SPEED
