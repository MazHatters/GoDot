extends Node2D

@onready var Background = $land/ColorRect


func _on_plate_1_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		var color = $Plate1/ColorRect.color
		Background.color = color


func _on_plate_2_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		var color = $Plate2/ColorRect.color
		Background.color = color



func _on_plate_3_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		var color = $Plate3/ColorRect.color
		Background.color = color
