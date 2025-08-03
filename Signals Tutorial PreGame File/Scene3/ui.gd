extends Control

@onready var healthbar = $PlayerHealth


func _on_example_3_player_update_player_health(health) -> void:
	healthbar.value = health
