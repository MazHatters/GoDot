class_name Player extends CharacterBody2D

signal laser_shot(laser)
signal died

@export var accel := 10.0
@export var max_speed := 350.0
@export var rotation_speed := 250

@onready var sprite = $AnimatedSprite2D
@onready var muzzle = $Muzzle
@onready var cshape = $CollisionShape2D

var laser_scene = preload("res://scene/laser.tscn")

var shoot_cd = false
var rate_of_fire = 0.3
var alive = true

func _process(_delta):
	if !alive: return
	if Input.is_action_pressed("vk_space"):
		if !shoot_cd:
			shoot_cd = true
			shoot_laser()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

func _physics_process(delta):
	if !alive: return
	var input_vector := Vector2(0, Input.get_axis("vk_up", "vk_down"))
	
	velocity += input_vector.rotated(rotation) * accel
	velocity = velocity.limit_length(max_speed)
	
	if Input.is_action_pressed("vk_right"):
		rotate(deg_to_rad(rotation_speed * delta))
	
	if Input.is_action_pressed("vk_left"):
		rotate(deg_to_rad(-rotation_speed * delta))
	
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 0.5)
		sprite.play("idle")
	if Input.is_action_pressed("vk_left"):
		sprite.play("tilting")
		sprite.flip_h = false
	elif Input.is_action_pressed("vk_right"):
		sprite.play("tilting")
		sprite.flip_h = true
	else:
		sprite.play("idle")
		
	
	move_and_slide()

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
		
func shoot_laser():
	var l = laser_scene.instantiate()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	emit_signal("laser_shot", l)

func die():
	if alive == true:
		alive = false
		emit_signal("died")
		sprite.visible = false
		
func respawn(pos):
	if alive == false:
		alive = true
		global_position = pos
		velocity = Vector2.ZERO
		sprite.visible = true
		
		
