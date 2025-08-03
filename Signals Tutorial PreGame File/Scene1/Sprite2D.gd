extends Sprite2D

var speed = 400
var angular_speed = PI
var toggled_on = true

func _process(delta):
	if toggled_on:
		rotation += angular_speed * delta
		var velocity = Vector2.UP.rotated(rotation) * speed
		position += velocity * delta

func toggle():
	toggled_on = !toggled_on


func _on_example_1_world_toggle_icon_spin() -> void:
	toggle()
