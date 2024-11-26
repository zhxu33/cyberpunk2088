class_name HitBox
extends Area2D


@export var damage:int = 10
@export var knockback:int = 0

func _init() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hurtbox:HurtBox) -> void:
	print("melee attack hitted")
	if hurtbox.get_owner().has_method("take_damage"):
		print("melee attack deal damage")
		hurtbox.owner.take_damage(damage)
