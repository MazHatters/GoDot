extends CharacterBody2D

signal damage_to_player

const SPEED = 500.0
@onready var player = get_parent().get_node("Example3Player")

func _physics_process(delta):
	position += (player.position - position) * delta
	look_at(player.position)
	
	move_and_slide()

func enemy():
	pass


func _on_damage_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		var damage = 20
		emit_signal("damage_to_player", damage)
