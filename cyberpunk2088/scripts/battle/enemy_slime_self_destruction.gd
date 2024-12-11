extends Area2D


@onready var enemy_slime: EnemySlime = $".."
var explosion_particle:PackedScene = preload("res://scenes/attacks/slime_explosion.tscn")


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _explode() -> void:
	var explosion = explosion_particle.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
		

func _on_body_entered(body: Node2D) -> void:
	if enemy_slime._dead:
		return
	if body is Player:
		print("ayte")
		enemy_slime.destruct()
		_explode()
		queue_free()
	