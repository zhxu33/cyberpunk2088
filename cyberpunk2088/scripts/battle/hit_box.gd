class_name HitBox
extends Area2D

var explosion_particle:PackedScene = preload("res://scenes/attacks/explosion.tscn")
@export var damage:int
@export var knockback:int



func _init() -> void:
	area_entered.connect(_on_area_entered)
	
	
func _explode() -> void:
	if Stats.upgrades["Exploding Attack"] > 0:
		var explosion = explosion_particle.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.add_child(explosion)
		

func _on_area_entered(area:Area2D) -> void:
	if (area is HurtBox) and area.get_owner().has_method("take_damage"):
		if get_owner() is Enemy and get_owner()._dead: 
			# dead enemy
			return
		if damage == 0:
			# player bullet
			return
		if area.get_owner() is Enemy:
			# player meele
			damage = 50 + 10 * Stats.upgrades["Attack Damage"]
			var crit_factor = 1
			if randf_range(1, 10) <= Stats.upgrades["Critical Chance"]:
				crit_factor = 2
			area.owner.take_damage(damage * crit_factor)
			_explode()
		else:
			# enemy attack
			area.owner.take_damage(damage)
