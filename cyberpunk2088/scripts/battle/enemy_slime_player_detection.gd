extends Area2D

@onready var enemy_slime: EnemySlime = $".."

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		enemy_slime.start_moving = true
		queue_free()
	
