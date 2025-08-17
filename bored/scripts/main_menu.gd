extends Control

@export var scene : String

# Handling Play button
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(scene)

# Handling Quit button
func _on_quit_pressed() -> void:
	get_tree().quit()
