class_name Asteroid extends Area2D

var movement_vector := Vector2(0, -1)

signal exploded(pos, size, points)

enum AsteroidSize{BIG,MEDIUM,SMALL}
@export var size := AsteroidSize.BIG

var speed := 50

@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D

var points: int:
	get:
		match size:
			AsteroidSize.BIG:
				return 50
			AsteroidSize.MEDIUM:
				return 100
			AsteroidSize.SMALL:
				return 200
			_:
				return 0

func _ready():
	rotation = randf_range(0, 2 * PI)
	
	match size:
		AsteroidSize.BIG:
			speed = randf_range(50, 100)
			sprite.texture = preload("res://asset/Asteroid_big.png")
			cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_big.tres"))
		AsteroidSize.MEDIUM:
			speed = randf_range(100, 150)
			sprite.texture = preload("res://asset/Asteroid_medium.png")
			cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_medium.tres"))
		AsteroidSize.SMALL:
			speed = randf_range(100, 200)
			sprite.texture = preload("res://asset/Asteroid_small.png")
			cshape.set_deferred("shape", preload("res://resources/asteroid_cshape_small.tres"))

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	var radius = cshape.shape.radius
	var screen_size = get_viewport().size
	if (global_position.y + radius) < 0:
		global_position.y = screen_size.y + radius
	elif (global_position.y - radius) > screen_size.y:
		global_position.y = -radius
		
	if (global_position.x + radius) < 0:
		global_position.x = screen_size.x + radius
	elif (global_position.x - radius) > screen_size.x:
		global_position.x = radius

func explode():
	emit_signal("exploded", global_position, size, points)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player = body
		player.die()
