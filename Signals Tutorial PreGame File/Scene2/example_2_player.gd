extends CharacterBody2D

const SPEED = 500.0
var health = 100

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var desired_velocity := SPEED * dir
	
	var steering := desired_velocity - velocity
	velocity += steering * 0.15
	
	move_and_slide()

func player():
	pass
