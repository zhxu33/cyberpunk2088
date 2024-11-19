class_name CameraController
extends Camera2D

@onready var player = get_node("/root/World/Player")  # Adjust this path to match your scene structure

func _ready() -> void:
	if player:
		global_position = player.global_position

func _process(_delta: float) -> void:
	if player:
		global_position = player.global_position
