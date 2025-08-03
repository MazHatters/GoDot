extends CharacterBody2D

signal update_player_health

const SPEED = 500.0
var health = 100

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var desired_velocity := SPEED * dir
	
	var steering := desired_velocity - velocity
	velocity += steering * 0.15
	
	move_and_slide()
	emit_signal("update_player_health", health)

func player():
	pass


func _on_example_3_enemy_damage_to_player(damage):
	take_damage(damage)
	
func take_damage(damage):
	health -= damage
	if health <= 0:
		health = 0
		emit_signal("update_player_health", health)
		set_physics_process(false) # Call death function
