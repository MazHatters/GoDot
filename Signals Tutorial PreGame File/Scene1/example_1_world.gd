extends Node2D


signal toggle_icon_spin

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("toggle_icon_spin")
