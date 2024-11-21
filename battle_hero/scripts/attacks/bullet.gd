class_name Bullet
extends CharacterBody2D


@export var damage: float = 25 + 5 * Stats.upgrades["Bullet Damage"]
@export var velo:Vector2
@onready var icon: TextureRect = $Icon
@onready var hitbox: Area2D = $Hitbox
@onready var hurtbox: Area2D = $Hurtbox

var explosion_particle:PackedScene = preload("res://scenes/attacks/explosion.tscn")
var pierced_amount:int = 0
var bounced_amount:int = 0

func _ready() -> void:
	hitbox.area_entered.connect(_on_area_entered)


func _physics_process(delta):
	var collision_info = move_and_collide(velo * delta)
	if collision_info:
		if bounced_amount < Stats.upgrades["Ricochet Bullet"]: 
			bounced_amount += 1
			velo = velo.bounce(collision_info.get_normal())
			rotation = velo.angle()
			_explode()
		else:
			_destroy()
	global_position += velo * delta

func _explode() -> void:
	if Stats.upgrades["Exploding Bullet"] > 0:
		var explosion = explosion_particle.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.add_child(explosion)
	
	
func _destroy() -> void:
	_explode()
	queue_free()


func _on_area_entered(hurtbox: Area2D) -> void:
	if hurtbox.get_owner() is Enemy and pierced_amount <= Stats.upgrades["Bullet Penetrate"]:
		pierced_amount += 1
		var crit = randf_range(1, 10)
		var crit_factor = 1
		if randf_range(1, 10) <= Stats.upgrades["Critical Chance"]:
			crit_factor = 2
		hurtbox.get_owner().take_damage(damage * crit_factor)
		_explode()
		if pierced_amount > Stats.upgrades["Bullet Penetrate"]:
			queue_free()
