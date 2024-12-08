extends Area2D
class_name EnemyDogBullet

@export var damage: int

var direction: Vector2
var speed: float = 300
var player: CharacterBody2D
var enemy_dog: Node
var player_function: Node

@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	player_function = get_node("/root/World/Punk_Player")
	player = player_function.tell_them_who_you_are()
	$Timer.start()


func _physics_process(delta: float) -> void:
	#direction = 
	#direction = sign(direction)
	global_position += Vector2(1, 0) * speed * delta
	if direction == Vector2.LEFT:
		animated_sprite.flip_h = true


func _on_body_entered(body: Node2D) -> void:
	if body == player:
		animated_sprite.play("hit")
		speed = 0
		signals.player_take_damage.emit(damage)
		#queue_free()


func _on_timer_timeout() -> void:
	queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		queue_free()
