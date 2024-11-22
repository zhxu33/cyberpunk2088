class_name Npc
extends CharacterBody2D

@onready var hitbox:Area2D = $Hitbox 
@onready var interface:Interface = get_tree().get_root().get_node("World/Interface")

func _on_area_entered(hurtbox: Area2D) -> void:
	if hurtbox.get_owner() is Player:
		interface.shop_dialog()
		
func _on_area_exited(hurtbox: Area2D) -> void:
	if hurtbox.get_owner() is Player:
		interface.close_dialog()
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.area_entered.connect(_on_area_entered)
	hitbox.area_exited.connect(_on_area_exited)
