class_name HitBox
extends Area2D


@export var damage:int
@export var knockback:int



func _init() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area:Area2D) -> void:
	if (area is HurtBox) and area.get_owner().has_method("take_damage"):
		if damage == 0:
			# player attack
			return
		area.owner.take_damage(damage)
