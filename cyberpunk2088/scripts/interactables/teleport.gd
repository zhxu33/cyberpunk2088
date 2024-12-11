extends Node2D


@onready var icon = $Icon


func _ready():
	var tween = get_tree().create_tween()
	var current_color = icon.modulate
	icon.modulate = Color(current_color.r, current_color.g, current_color.b, 0)
	var target_color = Color(current_color.r, current_color.g, current_color.b, 1)
	tween.tween_property(icon, "modulate", target_color, 1.0)
	
