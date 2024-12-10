class_name Npc
extends CharacterBody2D

@onready var hitbox:Area2D = $Hitbox 
@onready var dialogue:Control = get_tree().get_root().get_node("World/Interface/Canvas/Dialogue")
@onready var shop:Control = get_tree().get_root().get_node("World/Interface/Canvas/Shop")

func _on_area_entered(hurtbox: Area2D) -> void:
	if hurtbox.get_owner() is Player && not shop.visible:
		dialogue.visible = true
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.area_entered.connect(_on_area_entered)
