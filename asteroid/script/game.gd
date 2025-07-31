class_name game extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $asteroid_spawner/Asteroids

@onready var hud = $UI/HUD
@onready var game_over = $UI/GameOver

@onready var playerpos = $PlayerRespawnPos
@onready var spawn = $PlayerRespawnPos/Spawn

#@export var asteroid_packed_scene: PackedScene
@export var asteroid_count: int = 5

var asteroid_scene = preload("res://scene/asteroid.tscn")

var score := 0:
	set(value):
		score = value
		hud.score = score

var lives: int:
	set(value):
		lives = value
		hud.init_lives(lives)

func _ready():
	game_over.visible = false
	score = 0
	lives = 3
	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)
	$Background.visible = true
	$UI/Asteroid_on_spawn.visible = false
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)
		
	
func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if asteroids.get_child_count() == 0:
		spawn_asteroids()
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _on_player_laser_shot(laser):
	$Audio/LaserShoot.play()
	lasers.add_child(laser)

func _on_asteroid_exploded(pos, size, points):
	score += points
	$Audio/AsteroidHit.play()
	for i in range(2):
		match size:
			Asteroid.AsteroidSize.BIG:
				spawn_smaller_asteroids(pos, Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				spawn_smaller_asteroids(pos, Asteroid.AsteroidSize.SMALL)
			Asteroid.AsteroidSize.SMALL:
				pass
	#print(score)

func spawn_smaller_asteroids(pos, size):
	var a = asteroid_scene.instantiate()
	a.initialize(size)
	a.global_position = pos
	a.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", a)
	
func spawn_asteroids():
	for i in range(asteroid_count):
		var asteroid = asteroid_scene.instantiate()
		asteroid.initialize(Asteroid.AsteroidSize.BIG)
		asteroid.position = get_random_position_outside_area()
		asteroid.connect("exploded", _on_asteroid_exploded)
		asteroids.add_child(asteroid)

func get_random_position_outside_area() -> Vector2:
	var area = $asteroid_spawner
	var shape = area.get_node("CollisionShape2D").shape
	var size = shape.extents * 2  # Extents are half-size
	var center = area.global_position

	var margin = 100  # How far outside the screen to spawn

	var side = randi() % 4  # 0 = top, 1 = bottom, 2 = left, 3 = right
	match side:
		0:  # Top
			return Vector2(
				randf_range(center.x - size.x / 2, center.x + size.x / 2),
				center.y - size.y / 2 - margin
			)
		1:  # Bottom
			return Vector2(
				randf_range(center.x - size.x / 2, center.x + size.x / 2),
				center.y + size.y / 2 + margin
			)
		2:  # Left
			return Vector2(
				center.x - size.x / 2 - margin,
				randf_range(center.y - size.y / 2, center.y + size.y / 2)
			)
		3:  # Right
			return Vector2(
				center.x + size.x / 2 + margin,
				randf_range(center.y - size.y / 2, center.y + size.y / 2)
			)
			
	return center  # Fallback

func _on_player_died():
	lives -= 1
	player.global_position = playerpos.global_position
	$Audio/PlayerDied.play()
	#print(lives)
	if lives <= 0:
		await get_tree().create_timer(2).timeout
		game_over.visible = true
	else:
		await get_tree().create_timer(1).timeout
		while (!spawn.is_empty):
			$UI/Asteroid_on_spawn.visible = true
			await get_tree().create_timer(0.1).timeout
			$UI/Asteroid_on_spawn.visible = false
		player.respawn(playerpos.global_position)
