extends Control


# Handling Play button
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/main.tscn")

# Handling Quit button
func _on_quit_pressed() -> void:
	get_tree().quit()
